Settings
* Mở 2 Terminal của medical_backend
- Terminal 1:
  -  Nhập composer update
  -  Bỏ đuôi .example tại .env sau đó chỉnh sửa APP_URL= , MAPBOX_TOKEN=pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ
  -  Nhập tiếp php artisan migrate
  -  Theo đường dẫn medical-main\medical_backend\vendor\laravel\jetstream\src\Http\Livewire\UpdateProfileInformationForm.php
  -  Thêm đoạn mã này vào để hiển thị dữ liệu Profile trong Laravel

            use App\Models\Doctor;
            use Illuminate\Support\Facades\Auth;
            use Laravel\Fortify\Contracts\UpdatesUserProfileInformation;
            use Livewire\Component;
            use Livewire\WithFileUploads;
            public function mount()
            {
                $user = Auth::user();
                $doctor = Doctor::where('doc_id', $user->id)->first();
                $map = Map::where('doctor_id', $doctor->id)->first();
            
                $this->state = array_merge([
                    'email' => $user->email,
                ], $user->withoutRelations()->toArray());
            
                $this->state['experience'] = $doctor->experience;
                $this->state['bio_data'] = $doctor->bio_data;
                $this->state['category'] = $doctor->category;
                $this->state['location'] = $map->location ?? '';
                $this->state['longitude'] = $map->longitude ?? '';
                $this->state['latitude'] = $map->latitude ?? '';
            }
- Terminal 2:
  - Nhập lần lượt:
  - npm install
  - npm run build
  - npm run dev
* Chạy medical_ui
  - Window -> Edit environment variables for your account -> Nhấp vào Path -> New -> D:\APP\ToolAndroid\SDKAndroid\platform-tools (SDK cài ở ổ nào thì tìm ra để cài)
  - Nhập adb pair Ip-address:port -> Của điện thoại -> Nhập mã 6 số
  - Nhập adb connect Ip-address:port -> Của điện thoại 
  - Window - CMD - adb reverse tcp:8000 tcp:8000
* Chạy medical_backend
  - php artisan serve
  - npm run dev