package com.tytv.beentogether.features.lockscreen;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import java.util.ArrayList;

public class LockScreenViewModel extends ViewModel {

    MutableLiveData<ArrayList<Integer>> passwordNumbers;

    public LockScreenViewModel() {
        this.passwordNumbers = new MutableLiveData<>();
        passwordNumbers.setValue(new ArrayList<Integer>());
    }

    public LiveData<ArrayList<Integer>> getPasswordNumbers(){
        return passwordNumbers;
    }

    public void pushPadNumber(int number){
        ArrayList<Integer> value = passwordNumbers.getValue();

        if (passwordNumbers.getValue().size() > 5) return;
        value.add(number);

        passwordNumbers.setValue(value);
    }

    public void popPadNumber(){
        ArrayList<Integer> value = passwordNumbers.getValue();
        int lastIndex = value.size() -1;
        if (lastIndex < 0) return;

        value.remove(lastIndex);

        passwordNumbers.setValue(value);
    }
}
