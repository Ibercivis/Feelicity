package com.ibercivis.aqua;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnMarkerDragListener;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

public class MapLocation extends Activity implements OnMarkerDragListener {

	// Google Map
    private GoogleMap googleMap;
    
	Resources res;
	
	private Marker newSampleLocation;

	private static final LatLng centerZaragoza = new LatLng(41.6561,-0.8945);

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.maplocation);
		
		// Configure the map
        if (googleMap == null) {
            googleMap = ((MapFragment) getFragmentManager().findFragmentById(R.id.map_geolocation)).getMap();
 
            // check if map is created successfully or not
            if (googleMap == null) {
                Toast.makeText(getApplicationContext(),
                        "Sorry! unable to create maps", Toast.LENGTH_SHORT)
                        .show();
            }
        }
        
        googleMap.setOnMarkerDragListener(this);
        
		googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(centerZaragoza, 11));

		newSampleLocation = googleMap.addMarker(new MarkerOptions()
        	.position(centerZaragoza)
        	.anchor(0.5f,0.5f)
        	.icon(BitmapDescriptorFactory.fromResource(R.drawable.grey_drop_maplocation))
        	.draggable(true));

		final Button selectLocationButton = (Button) findViewById(R.id.select_location_button);

		selectLocationButton.setOnClickListener(new View.OnClickListener() {
	
			public void onClick(final View view) {
				Intent intent = new Intent();
				intent.putExtra("latitude", ((Double) newSampleLocation.getPosition().latitude).toString());
				intent.putExtra("longitude", ((Double) newSampleLocation.getPosition().longitude).toString());
				setResult(RESULT_OK, intent);
				finish();
			}
		});
	}

	@Override
	public void onMarkerDrag(Marker marker) {
	}

	@Override
	public void onMarkerDragEnd(Marker marker) {
	}

	@Override
	public void onMarkerDragStart(Marker marker) {	 
	}
}
