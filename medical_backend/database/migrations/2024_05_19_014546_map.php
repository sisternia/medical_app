<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('maps', function (Blueprint $table) {
            $table->increments('id');
            $table->string('location')->default('');
            $table->decimal('longitude', 10, 7)->default(0.0000000);
            $table->decimal('latitude', 10, 7)->default(0.0000000);
            $table->unsignedInteger('doctor_id')->nullable();
            $table->unsignedInteger('user_id')->nullable();
            $table->unsignedInteger('user_detail_id')->nullable();

            // Foreign key constraints
            $table->foreign('doctor_id')->references('id')->on('doctors')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('user_detail_id')->references('id')->on('user_details')->onDelete('cascade');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('maps');
    }
};
