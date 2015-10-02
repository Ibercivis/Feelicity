package com.bifi.feelicity;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RadioGroup;
import android.widget.TabHost;
import android.widget.TabHost.OnTabChangeListener;
import android.widget.TextView;

import com.bifi.feelicity.MapTools.CustomOverlayItem;
import com.bifi.feelicity.MapTools.EnhancedMapView;
import com.bifi.feelicity.MapTools.HttpConnection;
import com.bifi.feelicity.MapTools.MapItemizedOverlay;
import com.bifi.feelicity.MapTools.ParcelableAttachment;
import com.bifi.feelicity.MapTools.ParcelableGeoPoint;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;

public class Home extends MapActivity implements OnTabChangeListener {

	private MapActivity _this = this;
	CustomApp appState;
	Resources res;
	TabHost tabHost;

	private Boolean showProgressDialog = false;
	ProgressDialog progressDialog;
	JSONArray categories = new JSONArray();
	RadioGroup categoryGroup;

	// Map variables
	public EnhancedMapView mapView = null;
	public MapController mapController = null;
	List<Overlay> mapOverlays;
	public int maxZoomLevel = 17;
	public Boolean initialized = false;
	public MapItemizedOverlay userOverlay = null;
	Drawable green_drawable;
	Drawable red_drawable;

	Handler handler;

	// Search parameters
	public String mode = "map";
	public String search_type = "places";
	public String search_result = "places";
	public String max_latitude = "90";
	public String min_latitude = "-90";
	public String max_longitude = "180";
	public String min_longitude = "-180";
	public String order = "date";
	public int page = 1;

	public static final String PREFS_NAME = "Credentials";

	String commentId = new String();
	AlertDialog.Builder builder;

	GeoPoint placeGeoLocation;
	String placeCategory = new String();
	ArrayList<ParcelableAttachment> attachmentsArray = new ArrayList<ParcelableAttachment>();

	protected static final int PICK_GEOPOSITION = 1;
	protected static final int PICK_ATTACHMENTS = 2;

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	public void onTabChanged(String tabName) {
		if (tabName.equals("add_tab")) {
			// do something on the map
		} else if (tabName.equals("map_tab")) {
			// do something on the list
		}
	}

	// Configure the menu
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.home_menu, menu);
		return true;
	}

	// Actions when the menu is used
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		Intent myIntent;
		switch (item.getItemId()) {
		case R.id.search:
			myIntent = new Intent(this, Search.class);
			startActivityForResult(myIntent, 0);
			return true;
		case R.id.logout:
			appState.logged = false;
			return true;
		}
		return true;
	}

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.home);

		appState = ((CustomApp) getApplicationContext());
		res = getResources();

		SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
		String stored_email = settings.getString("email", "");
		String stored_password = settings.getString("password", "");

		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						Log.d("HttpConnection", "Connection Success");
						if (jsonResponse.get("status").toString().equals("OK")) {
							appState.logged = true;
						}
					} catch (Exception e) {
						e.printStackTrace();

					} finally {
					}

					break;
				}
				case HttpConnection.DID_ERROR: {
					Log.d("HttpConnection", "Connection Error");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("email", stored_email));
		nameValuePairs.add(new BasicNameValuePair("password", stored_password));

		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/common/login",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}

		Resources res = getResources(); // Resource object to get Drawables
		tabHost = (TabHost) findViewById(R.id.tabhost);// getTabHost();
														// // The
														// activity
														// TabHost

		tabHost.setup();
		tabHost.setOnTabChangedListener(this);

		// Initialize a TabSpec for the map tab and add it to the TabHost
		tabHost.addTab(tabHost
				.newTabSpec("map")
				.setIndicator(res.getText(R.string.btn_map_mode),
						res.getDrawable(R.drawable.ic_menu_mapmode))
				.setContent(R.id.map_tab));

		// Do the same for the search tab
		tabHost.addTab(tabHost
				.newTabSpec("add")
				.setIndicator(res.getText(R.string.btn_new_feelicity),
						res.getDrawable(R.drawable.btn_star_big_off_disable))
				.setContent(R.id.add_tab));

		tabHost.setCurrentTab(1);

		builder = new AlertDialog.Builder(this);

		GeoPoint userGeoLocation = appState.getUserGeolocation();

		if (userGeoLocation != null) {
			placeGeoLocation = userGeoLocation;
		}

		initUI();
	}

	public void initUI() {

		// Configure the map
		mapView = (EnhancedMapView) findViewById(R.id.mapview);
		mapController = mapView.getController();
		mapOverlays = mapView.getOverlays();

		mapView.postInvalidate();
		mapView.setSatellite(false);
		mapView.setStreetView(true);

		green_drawable = this.getResources().getDrawable(R.drawable.launcher);
		red_drawable = this.getResources().getDrawable(R.drawable.launcher);

		// Setup the buttons functions
		ImageButton zoom_in = (ImageButton) findViewById(R.id.zoom_in);
		zoom_in.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				mapController.zoomIn();
			}
		});

		ImageButton zoom_out = (ImageButton) findViewById(R.id.zoom_out);
		zoom_out.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				mapController.zoomOut();
			}
		});

		View.OnKeyListener pageChangeListener = new View.OnKeyListener() {

			public boolean onKey(View v, int keyCode, KeyEvent event) {
				// TODO Auto-generated method stub
				if (keyCode == KeyEvent.KEYCODE_ENTER
						&& !((EditText) v).getText().toString().equals("")) {
					page = Integer
							.parseInt(((EditText) v).getText().toString());
					search();
				}
				return false;
			}
		};

		EditText map_page_text = (EditText) findViewById(R.id.map_page_text);
		map_page_text.setOnKeyListener(pageChangeListener);

		final Button center_me = (Button) findViewById(R.id.center_me);
		center_me.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				mapController.setCenter(userOverlay.getItem(0).getPoint());
			}
		});

		// Periodic function to handle the user position
		final Handler locationHandler = new Handler();

		Runnable runnable = new Runnable() {

			public void run() {

				GeoPoint userGeolocation = appState.getUserGeolocation();

				// If the user is geolocated
				if (userGeolocation != null) {

					// Remove the previous user marker
					mapOverlays.remove(userOverlay);
					mapView.invalidate();

					// Draw the user marker
					MapItemizedOverlay itemizedOverlay = new MapItemizedOverlay(
							green_drawable, _this);

					CustomOverlayItem customOverlayItem = new CustomOverlayItem(
							userGeolocation,
							res.getString(R.string.msg_you_are_here),
							res.getString(R.string.msg_you_are_here), "user");

					itemizedOverlay.addOverlay(customOverlayItem);
					mapOverlays.add(itemizedOverlay);

					userOverlay = itemizedOverlay;

					// Center the map in the user if is not initialized
					if (!initialized && mode.equals("map")) {
						Runnable delayedSearch = new Runnable() {

							public void run() {
								getBounds();
								search();
							}
						};

						mapController.setZoom(14);
						mapController.animateTo(userGeolocation, delayedSearch);
					}

					// Show the "Center me" button
					center_me.setVisibility(View.VISIBLE);
				} else {

					// If the map has not been initialized
					if (!initialized) {
						search();
					}
				}

				// Delay it for the next time
				locationHandler.postDelayed(this,
						appState.getLocationInterval());
			}

		};

		// The first time it must be executed immediately
		locationHandler.postDelayed(runnable, 0);

		final EditText placeNameText = (EditText) findViewById(R.id.place_name_text);
		final EditText commentContentText = (EditText) findViewById(R.id.comment_content_text);

		final Button showMapButton = (Button) findViewById(R.id.show_map_button);
		showMapButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				Intent i = new Intent(Home.this, MapGeolocation.class);
				if (placeGeoLocation != null) {
					ParcelableGeoPoint parcelable = new ParcelableGeoPoint(
							placeGeoLocation);
					i.putExtra("pointGeoLocation", parcelable);
				}
				startActivityForResult(i, PICK_GEOPOSITION);
			}
		});

		final Button attachmentsButton = (Button) findViewById(R.id.attachments_button);
		attachmentsButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				Intent i = new Intent(Home.this, UploadFiles.class);
				i.putParcelableArrayListExtra("attachmentsArray",
						attachmentsArray);
				startActivityForResult(i, PICK_ATTACHMENTS);
			}
		});

		final Button saveButton = (Button) findViewById(R.id.save_button);
		saveButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {

				if (appState.logged) {
					String alertString = new String("");
					if (placeNameText.getText().toString().equals("")) {
						alertString = res
								.getString(R.string.msg_name_mandatory);
					} else if (commentContentText.getText().toString()
							.equals("")) {
						alertString = res
								.getString(R.string.msg_comment_content_mandatory);
					} else if (placeGeoLocation == null) {
						alertString = res
								.getString(R.string.msg_place_geolocation_not_set);
					}

					if (!alertString.equals("")) {
						builder.setMessage(alertString)
								.setCancelable(false)
								.setPositiveButton("OK",
										new DialogInterface.OnClickListener() {
											public void onClick(
													DialogInterface dialog,
													int id) {
												dialog.cancel();
											}
										});
						AlertDialog alert = builder.create();
						alert.show();
						return;
					}

					newPlace();
				} else {
					AlertDialog.Builder builder = new AlertDialog.Builder(_this);
					builder.setMessage(
							res.getString(R.string.msg_you_must_login))
							.setCancelable(false)
							.setPositiveButton(
									res.getString(R.string.btn_login),
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog, int id) {
											Intent myIntent = new Intent(_this,
													Login.class);
											startActivityForResult(myIntent, 0);
										}
									})
							.setNegativeButton(
									res.getString(R.string.btn_close),
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog, int id) {
											dialog.cancel();
										}
									});
					AlertDialog alert = builder.create();
					alert.show();
				}
			}

		});
	}

	public void search() {
		if (showProgressDialog) {
			progressDialog = ProgressDialog.show(Home.this, "",
					res.getString(R.string.msg_loading) + "...", true, true);
		}

		/* COMIENZO DE PETICION */
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						if (showProgressDialog) {
							showProgressDialog = false;
							progressDialog.cancel();
						}
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						Log.d("HttpConnection", "Connection Success");

						// Clear all the overlays
						mapOverlays.clear();
						mapView.invalidate();

						// Setup the page controls
						int currentPage = jsonResponse.getInt("current_page");
						int totalPages = jsonResponse.getInt("pages");

						EditText map_page_text = (EditText) findViewById(R.id.map_page_text);
						map_page_text.setText(Integer.toString(currentPage));

						TextView map_pages_text = (TextView) findViewById(R.id.map_pages_text);
						map_pages_text.setText(res.getString(R.string.msg_of)
								+ " " + Integer.toString(totalPages));

						// Draw the results in the map
						final JSONArray results = (JSONArray) jsonResponse
								.get("results");

						ArrayList<String> resultsNames = new ArrayList<String>();

						int maxLatitude = (int) (Double
								.parseDouble(max_latitude) * 1E6);
						int minLatitude = (int) (Double
								.parseDouble(min_latitude) * 1E6);
						int maxLongitude = (int) (Double
								.parseDouble(max_longitude) * 1E6);
						int minLongitude = (int) (Double
								.parseDouble(min_longitude) * 1E6);

						MapItemizedOverlay itemizedOverlay = new MapItemizedOverlay(
								red_drawable, _this);
						ArrayList<CustomOverlayItem> overlayItems = new ArrayList<CustomOverlayItem>();

						for (int i = 0; i < results.length(); i++) {
							JSONObject result = results.getJSONObject(i);

							resultsNames.add(result.getString("place_name"));

							int latitude = (int) (result.getDouble("latitude") * 1E6);
							int longitude = (int) (result
									.getDouble("longitude") * 1E6);

							if (i == 0) {
								maxLatitude = minLatitude = latitude;
								maxLongitude = minLongitude = longitude;
							}

							// Sets the minimum and maximum latitude so we can
							// span and zoom
							minLatitude = (minLatitude > latitude) ? latitude
									: minLatitude;
							maxLatitude = (maxLatitude < latitude) ? latitude
									: maxLatitude;
							// Sets the minimum and maximum latitude so we can
							// span and zoom
							minLongitude = (minLongitude > longitude) ? longitude
									: minLongitude;
							maxLongitude = (maxLongitude < longitude) ? longitude
									: maxLongitude;

							String id = result.getString("place_id");
							String type = "place";

							String resultString = "";
							resultString += res.getString(R.string.msg_author)
									+ ": " + result.getString("user_name")
									+ "\n";
							resultString += res
									.getString(R.string.msg_last_update)
									+ ": "
									+ result.getString("last_update")
									+ " by "
									+ result.getString("last_updater_name")
									+ "\n";
							resultString += res
									.getString(R.string.msg_comments)
									+ ": "
									+ result.getString("num_comments") + "\n";
							resultString += res.getString(R.string.msg_visits)
									+ ": " + result.getString("visits") + "\n";
							resultString += res
									.getString(R.string.msg_scorings)
									+ ": "
									+ "+"
									+ result.getString("positive_scorings")
									+ "\n";

							GeoPoint point = new GeoPoint(latitude, longitude);
							CustomOverlayItem customOverlayItem = new CustomOverlayItem(
									point, result.getString("place_name"),
									resultString, id, type);

							overlayItems.add(customOverlayItem);

						}
						itemizedOverlay.addOverlays(overlayItems);
						mapOverlays.add(itemizedOverlay);

						if (userOverlay != null) {
							mapOverlays.add(userOverlay);
						}

						if (!initialized) {
							initialized = true;

							if (userOverlay == null) {
								// Zoom to span from the list of points
								mapController.zoomToSpan(
										(maxLatitude - minLatitude),
										(maxLongitude - minLongitude));

								if (mapView.getZoomLevel() > maxZoomLevel) {
									mapController.setZoom(maxZoomLevel);
								}

								// Animate to the center cluster of points
								mapController.setCenter(new GeoPoint(
										(maxLatitude + minLatitude) / 2,
										(maxLongitude + minLongitude) / 2));
							}

							// If map mode, set the listener to the user
							// movements
							if (mode.equals("map")) {
								mapView.setOnIdleListener(new EnhancedMapView.OnIdleListener() {
									public void onIdle(MapView view,
											GeoPoint newCenter,
											GeoPoint oldCenter, int newZoom,
											int oldZoom) {
										getBounds();
										search();
									}
								});
							}
						}

					} catch (Exception e) {
						e.printStackTrace();

					} finally {
					}

					break;
				}
				case HttpConnection.DID_ERROR: {
					if (showProgressDialog) {
						showProgressDialog = false;
						progressDialog.cancel();
					}
					Log.d("HttpConnection", "Connection Error");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("mode", mode));
		nameValuePairs.add(new BasicNameValuePair("search_type", search_type));
		nameValuePairs.add(new BasicNameValuePair("search_result",
				search_result));
		nameValuePairs
				.add(new BasicNameValuePair("max_latitude", max_latitude));
		nameValuePairs
				.add(new BasicNameValuePair("min_latitude", min_latitude));
		nameValuePairs.add(new BasicNameValuePair("max_longitude",
				max_longitude));
		nameValuePairs.add(new BasicNameValuePair("min_longitude",
				min_longitude));
		nameValuePairs.add(new BasicNameValuePair("order", order));
		nameValuePairs.add(new BasicNameValuePair("page", Integer
				.toString(page)));

		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/home/search",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
		/* FIN DE PETICION */
	}

	public void getBounds() {
		int latitudeSpan = mapView.getLatitudeSpan();
		int longitudeSpan = mapView.getLongitudeSpan();

		max_latitude = ((Double) ((mapView.getMapCenter().getLatitudeE6() + (latitudeSpan / 2)) / 1E6))
				.toString();
		min_latitude = ((Double) ((mapView.getMapCenter().getLatitudeE6() - (latitudeSpan / 2)) / 1E6))
				.toString();
		max_longitude = ((Double) ((mapView.getMapCenter().getLongitudeE6() + (longitudeSpan / 2)) / 1E6))
				.toString();
		min_longitude = ((Double) ((mapView.getMapCenter().getLongitudeE6() - (longitudeSpan / 2)) / 1E6))
				.toString();

		Log.d("Map bounces", "maxlat: " + max_latitude + " minlat: "
				+ min_latitude + " maxlng: " + max_longitude + " minlng: "
				+ min_longitude);
	}

	public void newPlace() {
		progressDialog = ProgressDialog.show(Home.this, "",
				res.getString(R.string.msg_uploading_processing_data), true,
				true);

		final EditText placeNameText = (EditText) findViewById(R.id.place_name_text);
		final EditText commentContentText = (EditText) findViewById(R.id.comment_content_text);

		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						Log.d("HttpConnection", "Connection Success");

						if (jsonResponse.get("status").toString().equals("OK")) {
							commentId = jsonResponse.getString("comment_id");
							uploadFiles();
						} else {
							builder.setMessage(
									jsonResponse.get("message").toString())
									.setCancelable(false)
									.setPositiveButton(
											"OK",
											new DialogInterface.OnClickListener() {
												public void onClick(
														DialogInterface dialog,
														int id) {
													dialog.cancel();
												}
											});
							AlertDialog alert = builder.create();
							alert.show();
						}
					} catch (Exception e) {
						e.printStackTrace();

					} finally {
					}

					break;
				}
				case HttpConnection.DID_ERROR: {
					Log.d("HttpConnection", "Connection Error");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("place_name", placeNameText
				.getText().toString()));
		nameValuePairs.add(new BasicNameValuePair("comment_content",
				commentContentText.getText().toString()));
		nameValuePairs
				.add(new BasicNameValuePair("latitude",
						((Double) (placeGeoLocation.getLatitudeE6() / 1E6))
								.toString()));
		nameValuePairs
				.add(new BasicNameValuePair("longitude",
						((Double) (placeGeoLocation.getLongitudeE6() / 1E6))
								.toString()));

		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/content/new_place",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
	}

	public void uploadFiles() {

		final Handler uploadHandler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						Log.d("HttpConnection", "Connection Success");

						if (jsonResponse.get("status").toString().equals("OK")) {
							attachmentsArray.remove(0);
							uploadFiles();
						} else {
							builder.setMessage(
									jsonResponse.get("message").toString())
									.setCancelable(false)
									.setPositiveButton(
											"OK",
											new DialogInterface.OnClickListener() {
												public void onClick(
														DialogInterface dialog,
														int id) {
													dialog.cancel();
													uploadFiles();
												}
											});
							AlertDialog alert = builder.create();
							alert.show();
						}

					} catch (Exception e) {
						e.printStackTrace();

					} finally {
					}

					break;
				}
				case HttpConnection.DID_ERROR: {
					Log.d("HttpConnection", "Connection Error");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};

		if (attachmentsArray.size() > 0) {
			try {
				File f = new File(attachmentsArray.get(0).getPath());
				MultipartEntity entity = new MultipartEntity();
				entity.addPart("comment_id", new StringBody(commentId));
				entity.addPart("type", new StringBody(attachmentsArray.get(0)
						.getType()));
				if (attachmentsArray.get(0).getType().equals("image")) {
					entity.addPart("file", new FileBody(f));
				} else {
					entity.addPart("file",
							new StringBody(attachmentsArray.get(0).getPath()));
				}

				new HttpConnection(uploadHandler).post(
						appState.getHttpClient(), appState.getServerString()
								+ "/content/upload_file", entity);
			} catch (Exception e) {
				e.printStackTrace();

			} finally {
			}
		} else {
			progressDialog.cancel();
			builder.setMessage(
					res.getString(R.string.msg_place_saved_successfully))
					.setCancelable(false)
					.setPositiveButton("OK",
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int id) {
									dialog.cancel();
									
									final EditText placeNameText = (EditText) findViewById(R.id.place_name_text);
									final EditText commentContentText = (EditText) findViewById(R.id.comment_content_text);
									placeNameText.setText("");
									commentContentText.setText("");
									placeGeoLocation = null;
									placeCategory = new String();
									attachmentsArray = new ArrayList<ParcelableAttachment>();
									
									search();
								}
							});
			AlertDialog alert = builder.create();
			alert.show();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		Bundle extras;
		switch (requestCode) {
		case PICK_GEOPOSITION:
			extras = data.getExtras();
			placeGeoLocation = ((ParcelableGeoPoint) extras
					.getParcelable("pointGeoLocation")).getGeoPoint();
			break;
		case PICK_ATTACHMENTS:
			extras = data.getExtras();
			attachmentsArray = extras
					.getParcelableArrayList("attachmentsArray");
			break;
		}
	}
}
