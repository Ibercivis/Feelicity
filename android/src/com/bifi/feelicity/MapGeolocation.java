package com.bifi.feelicity;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.bifi.feelicity.MapTools.MapItemizedOverlay;
import com.bifi.feelicity.MapTools.ParcelableGeoPoint;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

public class MapGeolocation extends MapActivity {

	public final static int SUCCESS_RETURN_CODE = 1;
	
	private Resources res;

	GeoPoint pointGeoLocation = null;

	public MapView mapView = null;
	public MapController mapController = null;

	private MyLocationOverlay me = null;

	public MapItemizedOverlay userOverlay = null;
	List<Overlay> mapOverlays;
	Drawable green_drawable;

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mapgeolocation);
		
		res = getResources();

		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			if (extras.containsKey("pointGeoLocation")) {
				pointGeoLocation = ((ParcelableGeoPoint) extras
						.getParcelable("pointGeoLocation")).getGeoPoint();
			}
		}
		
		if (pointGeoLocation == null) {
			pointGeoLocation = getPoint(41.656348, -0.876565);
		}

		mapView = (MapView) findViewById(R.id.map_geolocation_view);
		mapController = mapView.getController();

		mapOverlays = mapView.getOverlays();
		green_drawable = this.getResources().getDrawable(
				R.drawable.launcher);

		mapView.getController().setCenter(pointGeoLocation);
		mapView.getController().setZoom(17);
		mapView.setBuiltInZoomControls(true);

		Drawable marker = getResources().getDrawable(R.drawable.launcher);
		marker.setBounds(0, 0, marker.getIntrinsicWidth(),
				marker.getIntrinsicHeight());

		mapView.getOverlays().add(new SitesOverlay(marker));

		me = new MyLocationOverlay(this, mapView);
		mapView.getOverlays().add(me);

		final Button closeMapButton = (Button) findViewById(R.id.close_map_button);
		closeMapButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				Intent intent = new Intent();
				ParcelableGeoPoint parcelable = new ParcelableGeoPoint(
						pointGeoLocation);
				intent.putExtra("placeGeoLocation", parcelable);
				setResult(SUCCESS_RETURN_CODE, intent);
				finish();
			}
		});
	}

	private GeoPoint getPoint(double lat, double lon) {
		return (new GeoPoint((int) (lat * 1000000.0), (int) (lon * 1000000.0)));
	}
	
	@Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
            if(keyCode == KeyEvent.KEYCODE_BACK){
            	Intent intent = new Intent();
            	ParcelableGeoPoint parcelable = new ParcelableGeoPoint(
            			pointGeoLocation);
				intent.putExtra("pointGeoLocation", parcelable);
				setResult(SUCCESS_RETURN_CODE, intent);
            }
            return super.onKeyDown(keyCode, event);
    }

	private class SitesOverlay extends ItemizedOverlay<OverlayItem> {
		private List<OverlayItem> items = new ArrayList<OverlayItem>();
		private Drawable marker = null;
		private OverlayItem inDrag = null;
		private ImageView dragImage = null;
		private int xDragImageOffset = 0;
		private int yDragImageOffset = 0;
		private int xDragTouchOffset = 0;
		private int yDragTouchOffset = 0;

		public SitesOverlay(Drawable marker) {
			super(marker);
			this.marker = marker;

			dragImage = (ImageView) findViewById(R.id.drag);
			xDragImageOffset = dragImage.getDrawable().getIntrinsicWidth() / 2;
			yDragImageOffset = dragImage.getDrawable().getIntrinsicHeight();

			items.add(new OverlayItem(pointGeoLocation, res.getString(R.string.msg_you_are_here), res.getString(R.string.msg_you_are_here)));

			populate();
		}

		@Override
		protected OverlayItem createItem(int i) {
			return (items.get(i));
		}

		@Override
		public void draw(Canvas canvas, MapView mapView, boolean shadow) {
			super.draw(canvas, mapView, shadow);

			boundCenterBottom(marker);
		}

		@Override
		public int size() {
			return (items.size());
		}

		@Override
		public boolean onTouchEvent(MotionEvent event, MapView mapView) {
			final int action = event.getAction();
			final int x = (int) event.getX();
			final int y = (int) event.getY();
			boolean result = false;

			if (action == MotionEvent.ACTION_DOWN) {
				for (OverlayItem item : items) {
					Point p = new Point(0, 0);

					mapView.getProjection().toPixels(item.getPoint(), p);

					if (hitTest(item, marker, x - p.x, y - p.y)) {
						result = true;
						inDrag = item;
						items.remove(inDrag);
						populate();

						xDragTouchOffset = 0;
						yDragTouchOffset = 0;

						setDragImagePosition(p.x, p.y);
						dragImage.setVisibility(View.VISIBLE);

						xDragTouchOffset = x - p.x;
						yDragTouchOffset = y - p.y;

						break;
					}
				}
			} else if (action == MotionEvent.ACTION_MOVE && inDrag != null) {
				setDragImagePosition(x, y);
				result = true;
			} else if (action == MotionEvent.ACTION_UP && inDrag != null) {
				dragImage.setVisibility(View.GONE);

				GeoPoint pt = mapView.getProjection().fromPixels(
						x - xDragTouchOffset, y - yDragTouchOffset);
				OverlayItem toDrop = new OverlayItem(pt, inDrag.getTitle(),
						inDrag.getSnippet());

				pointGeoLocation = pt;

				items.add(toDrop);
				populate();

				inDrag = null;
				result = true;
			}

			return (result || super.onTouchEvent(event, mapView));
		}
		
		@Override
		public boolean onTap(GeoPoint p, MapView mapView){
			if(super.onTap(p, mapView)) {
	            return true;
	        }
	        else {
	        	Log.d("onTap", "lat:" + p.getLatitudeE6() + " lng:" + p.getLongitudeE6());
	        	items.clear();
	        	mapView.invalidate();
	        	
				items.add(new OverlayItem(p, res.getString(R.string.msg_you_are_here), res.getString(R.string.msg_you_are_here)));
				populate();
				
				pointGeoLocation = p;
				
	            return true;
	        }           
		}

		private void setDragImagePosition(int x, int y) {
			RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) dragImage
					.getLayoutParams();

			lp.setMargins(x - xDragImageOffset - xDragTouchOffset, y
					- yDragImageOffset - yDragTouchOffset, 0, 0);
			dragImage.setLayoutParams(lp);
		}
	}

}
