package com.tytv.beentogether.components;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tytv.beentogether.R;

public class CheckBox extends View {

    private static boolean DF_IS_SELECTED_ATTRS = false;

    boolean isSelected;

    public CheckBox(Context context) {
        super(context);
        this.isSelected = DF_IS_SELECTED_ATTRS;
    }

    public CheckBox(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        isSelected = false;
        TypedArray a = context.obtainStyledAttributes(attrs,
                R.styleable.CheckBox, 0, 0);
        isSelected = a.getBoolean(R.styleable.CheckBox_isSelected, DF_IS_SELECTED_ATTRS);
        a.recycle();
    }

    @Override
    public void draw(Canvas canvas) {
        super.draw(canvas);
        if (isSelected) {
            drawSelectedState(canvas);
        }else{
            drawUnSelectedState(canvas);
        }
    }

    private void drawUnSelectedState(@NonNull Canvas canvas){
        Paint paint = new Paint();
        int x = getWidth();
        int y = getHeight();
        int radius = y / 2;
        paint.setStyle(Paint.Style.STROKE);
        paint.setColor(Color.WHITE);
        canvas.drawPaint(paint);
        // Use Color.parseColor to define HTML colors
        paint.setColor(Color.parseColor("#CD5C5C"));
        paint.setStyle(Paint.Style.STROKE);
        canvas.drawCircle(x / 2, y / 2, radius, paint);
    }

    private void drawSelectedState(@NonNull Canvas canvas){
        Paint paint = new Paint();
        int x = getWidth();
        int y = getHeight();
        int radius = y / 2;
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(Color.WHITE);
        canvas.drawPaint(paint);
        // Use Color.parseColor to define HTML colors
        paint.setColor(Color.parseColor("#CD5C5C"));
        paint.setStrokeWidth(2);
        canvas.drawCircle(x / 2, y / 2, radius, paint);
    }



}

