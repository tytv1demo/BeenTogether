package com.tytv.beentogether.components;

import android.animation.ValueAnimator;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.BindingAdapter;

import com.tytv.beentogether.R;

public class CheckBox extends View {

    private static boolean DF_CHECKED_ATTRS = false;

    private boolean checked;

    private ValueAnimator animator;

    float animatedValue;

    public CheckBox(Context context) {
        super(context);
        this.checked = DF_CHECKED_ATTRS;
    }

    public CheckBox(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        checked = false;
        TypedArray a = context.obtainStyledAttributes(attrs,
                R.styleable.CheckBox, 0, 0);
        checked = a.getBoolean(R.styleable.CheckBox_checked, DF_CHECKED_ATTRS);
        a.recycle();
    }

    @Override
    public void draw(Canvas canvas) {
        super.draw(canvas);
        if (checked) {
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
        canvas.drawPaint(paint);
        // Use Color.parseColor to define HTML colors

        paint.setStrokeWidth(2);
        canvas.drawCircle(x / 2, y / 2, radius, paint);
    }

    public void setChecked(boolean checked) {
        if (checked != this.checked){
            if (checked){
                final CheckBox self = this;
                animator = ValueAnimator.ofFloat(0, 100);
                animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                    @Override
                    public void onAnimationUpdate(ValueAnimator valueAnimator) {
                        float animationValue = (float) valueAnimator.getAnimatedValue();
                        self.animatedValue = animationValue;
                        self.postInvalidateOnAnimation();
                    }
                });

                animator.setDuration(100);
                animator.start();
            }
            this.checked = checked;
            invalidate();
        }

    }
}

