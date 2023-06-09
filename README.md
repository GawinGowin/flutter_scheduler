# flutter_scheduler

株式会社サポーターズ主催：【技育CAMP】マンスリーハッカソン vol.1【オンライン開催】<br>
日程：3月25日(土) 11:00 ~ 3月26日(日) 20:00
成果物リポジトリ

# おーとみーる
本アプリケーションは翌日の予定に関しての出発時刻と持ち物を管理できるメモアプリケーションです．<br>
出発地と目的地間の所要時間計算にはGoogleMapAPIを利用しています．

![image](https://user-images.githubusercontent.com/101625248/228148103-c3bd95a9-be7c-4a00-928c-d155303c5cfa.png)

上記の画像は日程終了時点のアプリ画面

## Getting Started

### 1. Clone the sample project

```js
$ git clone https://github.com/GawinGowin/flutter_scheduler
```

### 2. Copy the config.yaml file to config.yaml file.

Open your favorite code editor and copy `lib/config.example.yaml` to `lib/config.yaml` file.

```bash
$ cp lib/config.example.yaml lib/config.yaml
```

### 3. Modify config.yaml file

Generate token from [Set up your Google Cloud project](https://developers.google.com/maps/documentation/routes/cloud-setup).

```yaml title="lib/config.yaml"
"api_key": "Your GoogleMaps API Key"
```

### 4. Install the dependecies and run app

```js
flutter pub get
flutter run
```
