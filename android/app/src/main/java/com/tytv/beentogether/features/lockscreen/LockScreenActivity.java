package com.tytv.beentogether.features.lockscreen;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelProviders;

import android.content.Intent;
import android.os.Bundle;
import android.widget.LinearLayout;

import com.google.android.flexbox.FlexboxLayout;
import com.tytv.beentogether.R;
import com.tytv.beentogether.components.CheckBox;
import com.tytv.beentogether.databinding.ActivityLockScreenBinding;
import com.tytv.beentogether.features.sign_in.SignInActivity;
import com.tytv.beentogether.fragments.pad.NumberPadFragment;

import java.util.ArrayList;

public class LockScreenActivity extends AppCompatActivity {

    NumberPadFragment numberPadFragment;

    LockScreenViewModel viewModel;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityLockScreenBinding binding = DataBindingUtil.setContentView(this, R.layout.activity_lock_screen);

        viewModel = ViewModelProviders.of(this).get(LockScreenViewModel.class);

        binding.setViewModel(viewModel);
        binding.setLifecycleOwner(this);

        numberPadFragment = (NumberPadFragment) getSupportFragmentManager().findFragmentById(R.id.look_screen_fragment_number_pad);
        numberPadFragment.setListener(numberPadListener);

    }

    private NumberPadFragment.NumberPadListener numberPadListener = new NumberPadFragment.NumberPadListener() {
        @Override
        public void onPress(int number) {
            if (number == -1) {
                viewModel.popPadNumber();
                return;
            }
            viewModel.pushPadNumber(number);
            if(viewModel.passwordNumbers.getValue().size() > 5) {
                navigateToSignIn();
            }
        }
    };

    private void navigateToSignIn() {
        Intent signInIntent = new Intent(this, SignInActivity.class);
        startActivity(signInIntent);
    }

}
