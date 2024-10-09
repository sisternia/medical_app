<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\Reviews;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DocsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $doctor = Auth::user();
        $appointments = Appointments::where('doc_id', $doctor->id)->where('status', 'upcoming')->get();
        $reviews = Reviews::where('doc_id', $doctor->id)->where('status', 'active')->get();

        return view('dashboard')->with(['doctor'=>$doctor, 'appointments'=>$appointments, 'reviews'=>$reviews]);
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

        $reviews = new Reviews();

        $appointment = Appointments::where('id', $request->get('appointment_id'))->first();

        $reviews->user_id = Auth::user()->id;
        $reviews->doc_id = $request->get('doctor_id');
        $reviews->ratings = $request->get('ratings');
        $reviews->reviews = $request->get('reviews');
        $reviews->reviewed_by = Auth::user()->name;
        $reviews->status = 'active';
        $reviews->save();

        $appointment->status = 'complete';
        $appointment->save();

        return response()->json([
            'success'=>'The appointment has been completed and reviewed successfully!',
        ], 200);
    }

    public function getReviewsByDocId($doc_id) {
        $reviews = Reviews::where('doc_id', $doc_id)->get();
        return response()->json($reviews, 200);
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
        $doctor=User::with('doctor')->where('doc_id',$id);
         $name=$request->input('name');
        $experience=$request->input('experience');
        $bio=$request->input('bio_data');



    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
    public function returnViewDoctorEdit(Request $request,$id)
    {
        $user = User::find($id);
        $doctor=$user->doctor;







        return view('editDoctor',compact(['user','doctor']));

//        return response()->json(['status' => 'success', 'user' => $user,'user_details'=>$user_details], 200);
    }
}
