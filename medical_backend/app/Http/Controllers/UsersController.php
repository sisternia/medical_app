<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\User;
use App\Models\Doctor;
use App\Models\Map;
use App\Models\UserDetails;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = array(); //this will return a set of user and doctor data
        $user = Auth::user();
        $doctor = User::where('type', 'doctor')->get();
        $doctorData = Doctor::all();
        $date = now()->format('n/j/Y');

        $appointment = Appointments::where('status', 'upcoming')->where('date', $date)->first();

        $details = $user->user_details;

        foreach($doctorData as $data){
            foreach($doctor as $info){
                if($data['doc_id'] == $info['id']){
                    $data['doctor_name'] = $info['name'];
                    $data['doctor_profile'] = $info['profile_photo_url'];
                    if(isset($appointment) && $appointment['doc_id'] == $info['id']){
                        $data['appointments'] = $appointment;
                    }
                }
            }
        }

        $user['doctor'] = $doctorData;
        $user['details'] = $details;

        return $user;
    }

    public function updateProfilePhoto(Request $request)
    {
        $request->validate([
            'profile_photo' => 'required|image|max:2048',
        ]);

        $user = Auth::user();
        $photoPath = $request->file('profile_photo')->store('profile-photos', 'public');

        // Xóa ảnh cũ nếu có
        if ($user->profile_photo_path) {
            Storage::disk('public')->delete($user->profile_photo_path);
        }

        $user->profile_photo_path = $photoPath;
        $user->save();

        return response()->json(['message' => 'Profile photo updated successfully', 'profile_photo_path' => $photoPath]);
    }

    public function updateProfile(Request $request)
    {
        $user = auth()->user();

        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
        ]);

        $user->name = $validatedData['name'];
        $user->email = $validatedData['email'];
        $user->save();

        return response()->json(['status' => 'success', 'user' => $user], 200);
    }

        /**
     * Store a newly created resource in storage.
     */
    public function storeFavDoc(Request $request)
    {

        $saveFav = UserDetails::where('user_id',Auth::user()->id)->first();

        $docList = json_encode($request->get('favList'));

        //update fav list into database
        $saveFav->fav = $docList;  //and remember update this as well
        $saveFav->save();

        return response()->json([
            'success'=>'The Favorite List is updated',
        ], 200);
    }

    /**
    * Login.
    */
    public function login(Request $request)
    {
        $request->validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email'=> ['The provider credentials are incorrect'],
            ])->status(404);

        }
        return $user->createToken($request->email)->plainTextToken;
    }

    /**
    * Register.
    */
    public function register(Request $request)
    {
        //validate incoming inputs
        $request->validate([
            'name'=>'required|string',
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user = User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'type'=>'user',
            'password'=>Hash::make($request->password),
        ]);

        $userInfo = UserDetails::create([
            'user_id'=>$user->id,
            'status'=>'active',
        ]);

        // Create a new map entry
        Map::create([
            'user_id' => $user->id,
            'user_detail_id' => $userInfo->id,
            'location' => '', // Default blank location
            'longitude' => 0.0000000, // Default longitude
            'latitude' => 0.0000000, // Default latitude
            'doctor_id' => null,
        ]);

        return $user;
    }

    /**
    * Logout.
    */
    public function logout(){
        $user = Auth::user();
        $user->currentAccessToken()->delete();

        return response()->json([
            'success'=>'Logout successfully!',
        ], 200);
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
        //
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


    public function userManagement()
    {
        $users = array(); //this will return a set of user and doctor data
        $listUser = User::with('user_details')->where('type', 'user')->get();






        return view('userList',compact('listUser'));
    }
    public function doctorManagement()
    {
        $users = array(); //this will return a set of user and doctor data
        $listUser = User::with('doctor')->where('type', 'doctor')->get();



        return view('userList',compact('listUser'));
    }


    public function changeUserInfor(Request $request,$id)
    {
        $user = User::find($id);




        $user->name = $request->input('name') ;
        $user->email = $request->input('email');
    //  $user->user_details->bio_data=$request->input('bio');


        $user->save();
        // $user->user_details->save();
        $listUser = User::with('user_details')->where('type', 'user')->get();
        return view('userList',compact('listUser'));

    }

    public function returnViewUserEdit(Request $request,$id)
    {
        $user = User::find($id);
        $user_details=$user->user_details;






        return view('editUser',compact(['user','user_details']));

        return response()->json(['status' => 'success', 'user' => $user,'user_details'=>$user_details], 200);
    }

    public function adminDeleteUser(Request $request,$id)
    {
        $user = User::find($id);
        $user->delete();





        

        $listUser = User::with('user_details')->where('type', 'user')->get();
        return view('userList',compact('listUser'));    
    }

}
