<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class AppointmentsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //retrieve all appointments from the user
        $appointment = Appointments::where('user_id', Auth::user()->id)->get();
        $doctor = User::where('type', 'doctor')->get();
        $user = User::where('type','user')->get();

        //sorting appointment and doctor details
        //and get all related appointment
        foreach($appointment as $data){
            foreach($doctor as $info){
                $details = $info->doctor;
                if($data['doc_id'] == $info['id']){
                    $data['doctor_name'] = $info['name'];
                    $data['doctor_profile'] = $info['profile_photo_url']; //typo error found
                    $data['category'] = $details['category'];
                }
            }
        }

        return $appointment;
    }
    public function getAppointmentsByDocId($doc_id)
    {
        $appointments = Appointments::where('doc_id', $doc_id)
            ->with('user:id,name,email') 
            ->get();
    
        return response()->json($appointments, 200);
    }
    
    public function updateStatus(Request $request, $id)
    {
        $appointment = Appointments::find($id);
        if ($appointment) {
            if (Auth::check() && Auth::user()->id == $appointment->user_id) {
                // Authorized user updating their own appointment
                $appointment->status = $request->get('status');
                $appointment->save();
    
                return response()->json([
                    'success' => 'Appointment status updated successfully!',
                ], 200);
            } else {
                // General update (e.g., by admin or doctor)
                $appointment->status = $request->get('status');
                $appointment->save();
    
                return response()->json([
                    'success' => 'Appointment status updated successfully!',
                ], 200);
            }
        } else {
            return response()->json([
                'error' => 'Appointment not found or unauthorized',
            ], 404);
        }
    }
    


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //this controller is to store booking details post from mobile app
        $appointment = new Appointments();
        $appointment->user_id = Auth::user()->id;
        $appointment->doc_id = $request->get('doctor_id');
        $appointment->date = $request->get('date');
        $appointment->day = $request->get('day');
        $appointment->time = $request->get('time');
        $appointment->status = 'upcoming'; //new appointment will be saved as 'upcoming' by default
        $appointment->save();

        //if successfully, return status code 200
        return response()->json([
            'success'=>'New Appointment has been made successfully!',
        ], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
