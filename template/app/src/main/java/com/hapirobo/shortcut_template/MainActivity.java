package com.hapirobo.shortcut_template;

import android.content.ActivityNotFoundException;
import android.content.Intent;

import androidx.appcompat.app.AppCompatActivity;

import android.provider.Settings;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onResume() {
        super.onResume();

        String package_name = getResources().getString(R.string.package_name);
        launchApp(package_name);
    }

    protected void launchApp(String packageName) {
//        Intent mIntent = getPackageManager().getLaunchIntentForPackage(packageName);

        // https://developer.android.com/reference/android/provider/Settings.html
        Intent mIntent = new Intent(Settings.ACTION_CAST_SETTINGS);

        if (mIntent != null) {
            try {
                startActivity(mIntent);
            } catch (ActivityNotFoundException err) {
                Toast t = Toast.makeText(getApplicationContext(), R.string.app_not_found, Toast.LENGTH_SHORT);
                t.show();
            }
        }
    }
}
