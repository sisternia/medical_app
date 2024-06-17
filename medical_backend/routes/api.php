<?php

use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\DocsController;
use App\Http\Controllers\UsersController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MapController;

Route::post('/login',[UsersController::class,'login']);
Route::post('/register',[UsersController::class,'register']);

Route::middleware('auth:sanctum')->group(function() {
    Route::get('/user', [UsersController::class, 'index']);
    Route::post('/fav', [UsersController::class, 'storeFavDoc']);
    Route::post('/logout', [UsersController::class, 'logout']);
    Route::post('/user/profile', [UsersController::class, 'updateProfile']);
    Route::post('/user/profile-photo', [UsersController::class, 'updateProfilePhoto']);
    Route::post('/book', [AppointmentsController::class, 'store']);
    Route::get('/appointments', [AppointmentsController::class, 'index']);
    Route::post('/appointments/{id}/status', [AppointmentsController::class, 'updateStatus']);
    Route::get('/appointments/doc/{doc_id}', [AppointmentsController::class, 'getAppointmentsByDocId']);
    Route::post('/reviews', [DocsController::class, 'store']);
    Route::post('/maps', [MapController::class, 'store'])->name('maps.store');
    Route::get('/maps', [MapController::class, 'index'])->name('maps.index');
});