<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserDetails extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'bio_data',
        'fav',
        'status',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }

    public function map()
    {
        return $this->hasOne(Map::class);
    }
}
