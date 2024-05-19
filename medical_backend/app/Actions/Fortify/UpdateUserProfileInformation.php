<?php

namespace App\Actions\Fortify;

use App\Models\Doctor;
use App\Models\Map;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Laravel\Fortify\Contracts\UpdatesUserProfileInformation;

class UpdateUserProfileInformation implements UpdatesUserProfileInformation
{
    /**
     * Validate and update the given user's profile information.
     *
     * @param  array<string, mixed>  $input
     */
    public function update($user, array $input): void
    {
        Validator::make($input, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', Rule::unique('users')->ignore($user->id)],
            'photo' => ['nullable', 'mimes:jpg,jpeg,png', 'max:1024'],
            'experience' => ['nullable', 'integer'],
            'bio_data' => ['nullable', 'string'],
            'category' => ['nullable', 'string', 'max:255'],
            'location' => ['nullable', 'string'],
            'longitude' => ['nullable', 'numeric'],
            'latitude' => ['nullable', 'numeric'],
        ])->validateWithBag('updateProfileInformation');

        if (isset($input['photo'])) {
            $user->updateProfilePhoto($input['photo']);
        }

        if ($input['email'] !== $user->email &&
            $user instanceof MustVerifyEmail) {
            $this->updateVerifiedUser($user, $input);
        } else {
            $user->forceFill([
                'name' => $input['name'],
                'email' => $input['email'],
            ])->save();
        }

        $doctor = Doctor::where('doc_id', $user->id)->first();
        $doctor->update([
            'experience' => $input['experience'],
            'bio_data' => $input['bio_data'],
            'category' => $input['category'],
        ]);

        Map::updateOrCreate(
            ['doctor_id' => $doctor->id],
            [
                'location' => $input['location'],
                'longitude' => $input['longitude'],
                'latitude' => $input['latitude'],
                'user_id' => $user->id,
                'user_detail_id' => $user->userDetail->id ?? null,
            ]
        );
    }

    /**
     * Update the given verified user's profile information.
     *
     * @param  array<string, string>  $input
     */
    protected function updateVerifiedUser($user, array $input): void
    {
        $user->forceFill([
            'name' => $input['name'],
            'email' => $input['email'],
            'email_verified_at' => null,
        ])->save();

        $user->sendEmailVerificationNotification();
    }
}
