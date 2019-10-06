package com.tytv.beentogether.features.lockscreen;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.LinearLayout;

import com.google.android.flexbox.FlexboxLayout;
import com.tytv.beentogether.R;
import com.tytv.beentogether.components.CheckBox;
import com.tytv.beentogether.fragments.pad.NumberPadFragment;

import java.util.ArrayList;

public class LockScreenActivity extends AppCompatActivity {

    NumberPadFragment numberPadFragment;
    FlexboxLayout passwordCheckboxContainerView;
    ArrayList<CheckBox> passwordCheckBoxes;

    String password = "";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lock_screen);

        numberPadFragment = (NumberPadFragment) getSupportFragmentManager().findFragmentById(R.id.look_screen_fragment_number_pad);
        numberPadFragment.setListener(numberPadListener);

        passwordCheckboxContainerView = findViewById(R.id.lock_screen_checkbox_container);

        LinearLayout.LayoutParams checkboxLayoutParams = new LinearLayout.LayoutParams(
                50,
                50);

        for (int i = 0; i < 6; i++) {
            CheckBox checkBox = new CheckBox(this);
            passwordCheckboxContainerView.addView(checkBox, i, checkboxLayoutParams);
        }
    }

    private NumberPadFragment.NumberPadListener numberPadListener = new NumberPadFragment.NumberPadListener() {
        @Override
        public void onPress(int number) {
            if (number == -1) {
                if (password.isEmpty()) {
                    return;
                }
                password = password.substring(0, password.length() - 1);
            } else {
                password = password + number;
            }
        }
    };
}
