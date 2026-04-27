# LRS-NET Chat

A Flutter Android app for communicating with the LRS-Net base station over WiFi.

## Features

- **Chat tab** – real-time message bubbles (Hiker on left, Base on right)
- **GPS tab** – live GPS card (lat, lon, fix, altitude, course, date, time, RSSI, SNR) with "Open in Maps" button
- **Status bar** – green "Connected" / red "No signal" indicator
- **Auto-reconnect** – retries WebSocket connection every 3 seconds

## Prerequisites

1. Connect your Android phone to the `LRS-Net` WiFi hotspot (password: `basecamp1`) **before** opening the app.
2. The app connects to `ws://192.168.4.1/ws` automatically on launch.

## Building

```bash
flutter pub get
flutter build apk --release
```

The release APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## WebSocket Protocol

### Incoming (server → app)

```json
{"type":"gps","lat":"...","lon":"...","fix":"3","alt":"...","course":"...","date":"...","time":"...","rssi":"...","snr":"..."}
{"type":"chat","from":"hiker","text":"..."}
```

### Outgoing (app → server)

```json
{"type":"chat","text":"user message here"}
```

## Packages Used

| Package | Purpose |
|---|---|
| `web_socket_channel` | WebSocket client |
| `provider` | State management |
| `url_launcher` | Open Google Maps |
