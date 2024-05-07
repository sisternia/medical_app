<x-form-section submit="updateProfileInformation">
    <x-slot name="title">
        {{ __('Profile Information') }}
    </x-slot>

    <x-slot name="description">
        {{ __('Update your account\'s profile information and email address.') }}
    </x-slot>

    <x-slot name="form">
        <!-- Profile Photo -->
        @if (Laravel\Jetstream\Jetstream::managesProfilePhotos())
            <div x-data="{photoName: null, photoPreview: null}" class="col-span-6 sm:col-span-4">
                <!-- Profile Photo File Input -->
                <input type="file" id="photo" class="hidden"
                            wire:model.live="photo"
                            x-ref="photo"
                            x-on:change="
                                    photoName = $refs.photo.files[0].name;
                                    const reader = new FileReader();
                                    reader.onload = (e) => {
                                        photoPreview = e.target.result;
                                    };
                                    reader.readAsDataURL($refs.photo.files[0]);
                            " />

                <x-label for="photo" value="{{ __('Picture Profile') }}" />

                <!-- Current Profile Photo -->
                <div class="mt-2" x-show="! photoPreview">
                    <img src="{{ $this->user->profile_photo_url }}" alt="{{ $this->user->name }}" class="rounded-full h-20 w-20 object-cover">
                </div>

                <!-- New Profile Photo Preview -->
                <div class="mt-2" x-show="photoPreview" style="display: none;">
                    <span class="block rounded-full w-20 h-20 bg-cover bg-no-repeat bg-center"
                          x-bind:style="'background-image: url(\'' + photoPreview + '\');'">
                    </span>
                </div>

                <x-secondary-button class="mt-2 me-2" type="button" x-on:click.prevent="$refs.photo.click()">
                    {{ __('Select A New Photo') }}
                </x-secondary-button>

                @if ($this->user->profile_photo_path)
                    <x-secondary-button type="button" class="mt-2" wire:click="deleteProfilePhoto">
                        {{ __('Remove Photo') }}
                    </x-secondary-button>
                @endif

                <x-input-error for="photo" class="mt-2" />
            </div>
        @endif

        <!-- Name -->
        <div class="col-span-6 sm:col-span-4">
            <x-label for="name" value="{{ __('Name') }}" />
            <x-input id="name" type="text" class="mt-1 block w-full" wire:model="state.name" required autocomplete="name" />
            <x-input-error for="name" class="mt-2" />
        </div>

        <!-- Bio  Data-->
        <div class="col-span-6 sm:col-span-4">
            <x-label for="name" value="{{ __('Bio Data') }}" />
            <textarea class="mt-1 block w-full border-gray-300 focus:border-indigo-300 focus:ring-indigo-200 focus:ring-opacity-50 rounded-md shadow-sm" id="bio" wire:model.defer="state.bio_data" placeholder="Bio Data"></textarea>
            <x-input-error for="name" class="mt-2" />
        </div>

        <!-- Experience -->
        <div class="col-span-6 sm:col-span-4">
            <x-label for="experience" value="{{ __('Experience') }}" />
            <x-input id="experience" type="number" min="0" max="60" class="mt-1 block w-full" wire:model.defer="state.experience" autocomplete="experience" />
            <x-input-error for="experience" class="mt-2" />
        </div>

        <!-- Category -->
        <div class="col-span-6 sm:col-span-4">
            <x-label for="category" value="{{ __('Category') }}" />
            <x-input id="category" type="text" class="mt-1 block w-full" wire:model.defer="state.category" autocomplete="category" />
            <x-input-error for="category" class="mt-2" />
        </div>

        <!-- Location -->
        <div class="col-span-6 sm:col-span-4">
            <x-label for="location" value="{{ __('Location') }}" />
            <div class="mt-1 flex rounded-md shadow-sm">
                <x-input id="location" type="text" class="flex-1 block w-full rounded-l-md border-gray-300" wire:model.defer="state.location" autocomplete="location" />
                <span class="inline-flex items-center px-4 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-sm">
                    <button type="button" onclick="document.getElementById('location').value = ''">{{ __('Reset') }}</button>
                </span>
            </div>
            <x-input-error for="location" class="mt-2" />
        </div>

        <!-- Iframe -->
        <div class="col-span-6 sm:col-span-4">
            <div id='map' style='width: 100%; height: 300px;'></div>

            <script>
                mapboxgl.accessToken = 'pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ';
                const map = new mapboxgl.Map({
                    container: 'map', // container ID
                    style: 'mapbox://styles/mapbox/streets-v12', // style URL
                    center: [-74.5, 40], // starting position [lng, lat]
                    zoom: 9, // starting zoom
                });
            </script>

            <script>
                map.on('load', function () {
                    // Tạo sự kiện click cho bản đồ
                    map.on('click', function (e) {
                        // Xóa marker hiện tại (nếu có)
                        if (typeof marker !== 'undefined') {
                            marker.remove();
                        }

                        // Thêm marker mới vào vị trí người dùng nhấp
                        marker = new mapboxgl.Marker()
                            .setLngLat(e.lngLat)
                            .addTo(map);

                        // Sử dụng dịch vụ địa chỉ địa lý của Mapbox để lấy tên địa điểm từ tọa độ
                        fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${e.lngLat.lng},${e.lngLat.lat}.json?access_token=pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ`)
                            .then(response => response.json())
                            .then(data => {
                                // Cập nhật giá trị của input text với tên địa điểm
                                document.getElementById('location').value = data.features[0].place_name;
                            });
                    });
                });
            </script>
        </div>

        </script>
        <!-- Email -->
        <div class="col-span-6 sm:col-span-4">
            <x-label for="email" value="{{ __('Email') }}" />
            <x-input id="email" type="email" class="mt-1 block w-full" wire:model="state.email" required autocomplete="username" />
            <x-input-error for="email" class="mt-2" />

            @if (Laravel\Fortify\Features::enabled(Laravel\Fortify\Features::emailVerification()) && ! $this->user->hasVerifiedEmail())
                <p class="text-sm mt-2">
                    {{ __('Your email address is unverified.') }}

                    <button type="button" class="underline text-sm text-gray-600 hover:text-gray-900 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" wire:click.prevent="sendEmailVerification">
                        {{ __('Click here to re-send the verification email.') }}
                    </button>
                </p>

                @if ($this->verificationLinkSent)
                    <p class="mt-2 font-medium text-sm text-green-600">
                        {{ __('A new verification link has been sent to your email address.') }}
                    </p>
                @endif
            @endif
        </div>
    </x-slot>

    <x-slot name="actions">
        <x-action-message class="me-3" on="saved">
            {{ __('Saved.') }}
        </x-action-message>

        <x-button wire:loading.attr="disabled" wire:target="photo">
            {{ __('Save') }}
        </x-button>
    </x-slot>
</x-form-section>
