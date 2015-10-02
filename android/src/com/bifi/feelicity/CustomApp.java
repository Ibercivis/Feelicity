package com.bifi.feelicity;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.DefaultHttpClient;

import android.app.Application;
import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;

import com.google.android.maps.GeoPoint;

public class CustomApp extends Application {
	// Google Maps Api Key for debug: 0gi1a7NvhHJ5iivif1Fpq-EpzoyzCkX2Xa00eHg
	public String serverString = "http://www.feelicity.es";
	public HttpClient httpClient = new DefaultHttpClient();

	public Boolean logged = false;

	public Location userLocation = null;
	public int locationInterval = 10000;

	@Override
	public void onCreate() {
		super.onCreate();

		/* Use the LocationManager class to obtain GPS locations */

		LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		if (locationManager != null) {
			LocationListener locationListener = new MyLocationListener();
			String provider;
			
			if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
				provider = LocationManager.NETWORK_PROVIDER;
			} else {
				//If there is no GPS
				provider = LocationManager.NETWORK_PROVIDER;
			}
			
			int meters = 20; // Minimum distance in meters to notify
			locationManager.requestLocationUpdates(
					provider,
					locationInterval, meters, locationListener);
	
			// Get the last location of the user to increase speed
			userLocation = locationManager.getLastKnownLocation(provider);
		}
	}

	public String getServerString() {
		return serverString;
	}

	public void setServerString(String s) {
		serverString = s;
	}

	public HttpClient getHttpClient() {
		return httpClient;
	}

	public GeoPoint getUserGeolocation() {
		if (userLocation != null) {
			return new GeoPoint((int) (userLocation.getLatitude() * 1E6),
					(int) (userLocation.getLongitude() * 1E6));
		} else {
			return null;
		}
	}

	public int getLocationInterval() {
		return locationInterval;
	}

	private static final int TWO_MINUTES = 1000 * 60 * 2;

	/**
	 * Determines whether one Location reading is better than the current
	 * Location fix
	 * 
	 * @param location
	 *            The new Location that you want to evaluate
	 * @param currentBestLocation
	 *            The current Location fix, to which you want to compare the new
	 *            one
	 */
	protected boolean isBetterLocation(Location location,
			Location currentBestLocation) {
		if (currentBestLocation == null) {
			// A new location is always better than no location
			return true;
		}

		// Check whether the new location fix is newer or older
		long timeDelta = location.getTime() - currentBestLocation.getTime();
		boolean isSignificantlyNewer = timeDelta > TWO_MINUTES;
		boolean isSignificantlyOlder = timeDelta < -TWO_MINUTES;
		boolean isNewer = timeDelta > 0;

		// If it's been more than two minutes since the current location, use
		// the new location
		// because the user has likely moved
		if (isSignificantlyNewer) {
			return true;
			// If the new location is more than two minutes older, it must be
			// worse
		} else if (isSignificantlyOlder) {
			return false;
		}

		// Check whether the new location fix is more or less accurate
		int accuracyDelta = (int) (location.getAccuracy() - currentBestLocation
				.getAccuracy());
		boolean isLessAccurate = accuracyDelta > 0;
		boolean isMoreAccurate = accuracyDelta < 0;
		boolean isSignificantlyLessAccurate = accuracyDelta > 200;

		// Check if the old and new location are from the same provider
		boolean isFromSameProvider = isSameProvider(location.getProvider(),
				currentBestLocation.getProvider());

		// Determine location quality using a combination of timeliness and
		// accuracy
		if (isMoreAccurate) {
			return true;
		} else if (isNewer && !isLessAccurate) {
			return true;
		} else if (isNewer && !isSignificantlyLessAccurate
				&& isFromSameProvider) {
			return true;
		}
		return false;
	}

	/** Checks whether two providers are the same */
	private boolean isSameProvider(String provider1, String provider2) {
		if (provider1 == null) {
			return provider2 == null;
		}
		return provider1.equals(provider2);
	}

	/* Class My Location Listener */
	public class MyLocationListener implements LocationListener {
		public void onLocationChanged(Location loc) {
			if (isBetterLocation(loc, userLocation)) {
				userLocation = loc;
				Log.d("Location", "Latitude = " + userLocation.getLatitude()
						+ ", Longitude = " + userLocation.getLongitude());
			}
		}

		public void onProviderDisabled(String provider) {
			Log.d("Location", provider + "Disabled");
		}

		public void onProviderEnabled(String provider) {
			Log.d("Location", provider + "Enabled");
		}

		public void onStatusChanged(String provider, int status, Bundle extras) {

		}
	}/* End of Class MyLocationListener */
}
