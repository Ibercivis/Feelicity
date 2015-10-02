package com.bifi.feelicity.MapTools;

import android.graphics.Canvas;
import android.view.MotionEvent;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;

public class EnhancedMapView extends MapView {
	
	private EnhancedMapView _this = this;
	
	private EnhancedMapView.OnZoomChangeListener zoom_change_listener = null;
	private EnhancedMapView.OnPanChangeListener pan_change_listener = null;
	private EnhancedMapView.OnIdleListener idle_listener = null;
	
	private int lastZoomLevel = this.getZoomLevel();
	private GeoPoint lastCenterPosition = this.getMapCenter();

	public interface OnZoomChangeListener {
		public void onZoomChange(MapView view, int newZoom, int oldZoom);
	}

	public interface OnPanChangeListener {
		public void onPanChange(MapView view, GeoPoint newCenter,
				GeoPoint oldCenter);
	}
	
	public interface OnIdleListener {
		public void onIdle(MapView view, GeoPoint newCenter,
				GeoPoint oldCenter, int newZoom, int oldZoom);
	}

	public EnhancedMapView(android.content.Context context,
			android.util.AttributeSet attrs) {
		super(context, attrs);
	}

	public EnhancedMapView(android.content.Context context,
			android.util.AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public EnhancedMapView(android.content.Context context,
			java.lang.String apiKey) {
		super(context, apiKey);
	}
	
	public void setOnZoomChangeListener(EnhancedMapView.OnZoomChangeListener l) {
	    zoom_change_listener = l;
	}
	
	public void removeOnZoomChangeListener() {
	    zoom_change_listener = null;
	}

	public void setOnPanChangeListener(EnhancedMapView.OnPanChangeListener l) {
	    pan_change_listener = l;
	}
	
	public void removeOnPanChangeListener() {
	    pan_change_listener = null;
	}
	
	public void setOnIdleListener(EnhancedMapView.OnIdleListener l) {
	    idle_listener = l;
	}
	
	public void removeOnIdleListener() {
	    idle_listener = null;
	}

	public boolean onTouchEvent(MotionEvent ev) {
		Boolean eventResult = super.onTouchEvent(ev);
		if (ev.getAction() == MotionEvent.ACTION_UP) {
			// if the map center has changed do your thing
			if (!lastCenterPosition.equals(getMapCenter())) {
				if (pan_change_listener != null) {
					pan_change_listener.onPanChange(_this, getMapCenter(),lastCenterPosition);
				}
				if (idle_listener != null) {
					idle_listener.onIdle(_this, getMapCenter(), lastCenterPosition, getZoomLevel(), lastZoomLevel);
				}
				lastCenterPosition = getMapCenter();
			}
		}
		return eventResult;
	}

	public void dispatchDraw(Canvas canvas) {
		super.dispatchDraw(canvas);
		if (getZoomLevel() != lastZoomLevel) {
			// do your thing
			if (zoom_change_listener != null) {
				zoom_change_listener.onZoomChange(_this, getZoomLevel(),
						lastZoomLevel);
			}
			if (idle_listener != null) {
				idle_listener.onIdle(_this, getMapCenter(),
						lastCenterPosition, getZoomLevel(),
						lastZoomLevel);
			}
			lastZoomLevel = getZoomLevel();
		}
	}
}
