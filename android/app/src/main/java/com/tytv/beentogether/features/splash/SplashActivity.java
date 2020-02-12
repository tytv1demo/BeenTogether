package com.tytv.beentogether.features.splash;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;

import com.tytv.beentogether.R;
import com.tytv.beentogether.features.lockscreen.LockScreenActivity;
import com.tytv.beentogether.features.main.MainActivity;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        Intent mainActivityIntent = new Intent(this, LockScreenActivity.class);
        startActivity(mainActivityIntent);
    }

}
