<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Map;

class MapController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'location' => 'required|string|max:255',
            'longitude' => 'required|numeric',
            'latitude' => 'required|numeric',
        ]);

        $map = new Map();
        $map->location = $request->location;
        $map->longitude = $request->longitude;
        $map->latitude = $request->latitude;
        $map->doctor_id = $request->doctor_id;
        $map->user_id = $request->user_id;
        $map->user_detail_id = $request->user_detail_id;
        $map->save();
    }

    public function index()
    {
        $locations = Map::all();
        return response()->json($locations, 200);
    }
}
