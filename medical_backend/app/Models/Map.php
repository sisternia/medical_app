<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Map extends Model
{
    use HasFactory;

    protected $fillable = [
        'location',
        'longitude',
        'latitude',
        'doctor_id',
        'user_id',
        'user_detail_id',
    ];

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function userDetail()
    {
        return $this->belongsTo(UserDetails::class);
    }
}
