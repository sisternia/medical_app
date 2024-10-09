<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DocsController;

Route::get('/', function () {
    return view('welcome');
});

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified'
])->group(function () {
    Route::get('/dashboard', [DocsController::class, 'index'])->name('dashboard');
    Route::get('/admin', [\App\Http\Controllers\UsersController::class,'adminDashboard'])->name('adminView');

    Route::get('/admin/users',[\App\Http\Controllers\UsersController::class,'userManagement'])->name('userManage');


    Route::put('/admin/users/{id}',[\App\Http\Controllers\UsersController::class,'changeUserInfor'])->name('editUser');
    Route::get('/admin/users/{id}',[\App\Http\Controllers\UsersController::class,'returnViewUserEdit'])->name('editUserView');








    Route::put('/admin/doctors/{id}',[\App\Http\Controllers\UsersController::class,'changeDoctorInfor'])->name('editDoctor');
    Route::get('/admin/doctors/{id}',[\App\Http\Controllers\DocsController::class,'returnViewDoctorEdit'])->name('editDoctorView');



    Route::put('/admin/doctors/{id}/edit',function (){
        return view('editUser');
    });
    Route::get('/admin/doctors',[\App\Http\Controllers\UsersController::class,'doctorManagement'])->name('doctorManage');
    Route::delete('/admin/users/{id}',[\App\Http\Controllers\UsersController::class,'adminDeleteUser'])->name('adminDeleteUser');
    Route::delete('/admin/doctors/{id}/',[\App\Http\Controllers\UsersController::class,'adminDeleteDoctor'])->name('adminDeleteDoctor');

});

