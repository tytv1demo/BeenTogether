package com.tytv.beentogether.fragments.pad;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;

import com.tytv.beentogether.R;
import com.tytv.beentogether.databinding.FragmentNumberPadBinding;


public class NumberPadFragment extends Fragment implements INumberPadFragment {

    static String DEL_PAD = "DEL";

    NumberPadListener listener;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        FragmentNumberPadBinding binding = DataBindingUtil.inflate(inflater, R.layout.fragment_number_pad, container, false);

        binding.setManager(this);

        return binding.getRoot();
    }

    @Override
    public void onPressOn(View view) {
        Button pad = (Button) view;
        String padValue = pad.getText().toString();

        int padNumber = -1;

        if (padValue.compareToIgnoreCase(NumberPadFragment.DEL_PAD) != 0) {
            padNumber = Integer.parseInt(pad.getText().toString());
        }

        if(listener != null) {
            listener.onPress(padNumber);
        }
    }

    public interface NumberPadListener {
        void onPress(int number);
    }

    public void setListener(NumberPadListener listener) {
        this.listener = listener;
    }
}
