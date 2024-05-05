Settings
* Mở 2 Terminal của medical_backend
- Terminal 1:
      -  Nhập composer update
      -  Bỏ đuôi .example tại .env sau đó chỉnh sửa APP_URL=http://127.0.0.1:8000
      -  Nhập tiếp php artisan migrate
      -  Theo đường dẫn medical-main\medical_backend\vendor\laravel\jetstream\src\Http\Livewire\UpdateProfileInformationForm.php
      -  Thêm đoạn mã này vào để hiển thị dữ liệu Profile trong Laravel

            public function mount()
              {
              $user = Auth::user();

              $this->state = array_merge([
                  'email' => $user->email,
              ], $user->withoutRelations()->toArray());

              $this->state['experience'] = Doctor::where('doc_id',$user->id)->first()->experience;
              $this->state['bio_data'] = Doctor::where('doc_id',$user->id)->first()->bio_data;
              $this->state['category'] = Doctor::where('doc_id',$user->id)->first()->category;
              }
- Terminal 2:
      - Nhập lần lượt:
      - npm install
      - npm run build
      - npm dev run
* Chạy medical_ui
      - Window -> Edit environment variables for your account -> Nhấp vào Path -> New -> D:\APP\ToolAndroid\SDKAndroid\platform-tools (SDK cài ở ổ nào thì tìm ra để cài)
      - Window - CMD - adb reverse tcp:8000 tcp:8000
