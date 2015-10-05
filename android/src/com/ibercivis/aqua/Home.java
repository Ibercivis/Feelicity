package com.ibercivis.aqua;

import java.io.File;
import java.text.DecimalFormat;
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

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.TabHost;
import android.widget.Toast;
import android.widget.TabHost.OnTabChangeListener;

import com.ibercivis.aqua.R;
import com.ibercivis.aqua.MapTools.HttpConnection;
import com.ibercivis.aqua.MapTools.ParcelableAttachment;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

public class Home extends Activity implements OnTabChangeListener {

	// Google Map
    private GoogleMap googleMap;
    
    private Activity _this = this;
	CustomApp appState;
	Resources res;
	TabHost tabHost;

	private Boolean showProgressDialog = false;
	ProgressDialog progressDialog;
	JSONArray categories = new JSONArray();
	RadioGroup categoryGroup;

	// Map variables
	public Boolean initialized = false;

	Handler handler;

	public static final String PREFS_NAME = "Credentials";

	String placeId = new String();
	String commentId = new String();
	AlertDialog.Builder builder;

	ArrayList<ParcelableAttachment> attachmentsArray = new ArrayList<ParcelableAttachment>();

	protected static final int GEOPOSITION = 1;
	protected static final int IMAGE = 2;
	
	LinearLayout filesLayout;
	private static final LatLng centerZaragoza = new LatLng(41.6561,-0.8945);

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
	
	private static String latitudeGeoLocation = null;
	private static String longitudeGeoLocation = null;

	boolean error_saving_image = false;
	
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
		
		switch (item.getItemId()) {
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
//Log.d("HttpConnection", "Starting Connection Login Home");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
//Log.d("HttpConnection", "Connection Success Login Home");
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
//Log.d("HttpConnection", "Connection Error");
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
				.setIndicator(res.getText(R.string.btn_new_sample),
						res.getDrawable(R.drawable.grey_drop_button))
				.setContent(R.id.add_tab));

		tabHost.setCurrentTab(1);

		builder = new AlertDialog.Builder(this);

		initUI();
	}

	public void initUI() {

		// Configure the map
		
		try {
            // Loading map
            initilizeMap();
 
        } catch (Exception e) {
            e.printStackTrace();
        }
        
		final EditText placeNameText = (EditText) findViewById(R.id.place_name_text);
		final EditText pHText = (EditText) findViewById(R.id.ph_text);
		final EditText chlorineText = (EditText) findViewById(R.id.chlorine_text);
        
		final Button mapLocationButton = (Button) findViewById(R.id.show_map_button);
			mapLocationButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				Intent myIntent = new Intent(_this,
						MapLocation.class);
				startActivityForResult(myIntent, GEOPOSITION);
			}
		});
		
		final Button attachmentsButton = (Button) findViewById(R.id.image_sample_button);
		attachmentsButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("image/*");
				startActivityForResult(intent, IMAGE);
			}
		});

		final Button saveButton = (Button) findViewById(R.id.save_button);
		saveButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {

				if (appState.logged) {
					String alertString = new String("");
					if (placeNameText.getText().toString().equals("")) {
						alertString = res
								.getString(R.string.msg_place_name_mandatory);
					} else if (pHText.getText().toString()
							.equals("")) {
						alertString = res
								.getString(R.string.msg_ph_mandatory);
					} else if (chlorineText.getText().toString()
							.equals("")) {
						alertString = res
								.getString(R.string.msg_chlorine_mandatory);
					}
					else if ((latitudeGeoLocation == null) || (longitudeGeoLocation == null)) {
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

					newSample();
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

	// Load the map or create it if does not exist
    private void initilizeMap() {
        if (googleMap == null) {
            googleMap = ((MapFragment) getFragmentManager().findFragmentById(R.id.map)).getMap();
 
            // check if map is created successfully or not
            if (googleMap == null) {
                Toast.makeText(getApplicationContext(),
                        "Sorry! unable to create maps", Toast.LENGTH_SHORT)
                        .show();
            }
        }
        
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(centerZaragoza, 11));

		populateMap();
    }
	
    // Request and place the samples uploaded in the map
	public void populateMap() {
		if (showProgressDialog) {
			progressDialog = ProgressDialog.show(Home.this, "",
					res.getString(R.string.msg_loading) + "...", true, true);
		}

		// Starts the thread to request the samples uploaded
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
					case HttpConnection.DID_START: {
//Log.d("HttpConnection", "Markers Starting Connection");
						break;
					}
					case HttpConnection.DID_SUCCEED: {
						try {
							if (showProgressDialog) {
								showProgressDialog = false;
								progressDialog.cancel();
							}
							JSONObject jsonResponse = new JSONObject((String) message.obj);
//Log.d("HttpConnection", "Markers Connection Success");
							
							// Clean previous map (if there were)
							googleMap.clear();
							
							// Draw the results in the map
							final JSONArray results = (JSONArray) jsonResponse.get("results");
							
							ArrayList<String> resultsNames = new ArrayList<String>();
							
							// Go through the whole samples uploaded
							for (int i = 0; i < results.length(); i++) {
								JSONObject result = results.getJSONObject(i);

								resultsNames.add(result.getString("place_name"));

								String lat = result.getString("latitude");
								String lon = result.getString("longitude");
								double latitude = Double.parseDouble(lat);
								double longitude = Double.parseDouble(lon);
								
								// Set the tooltip for the marker with the ph and chlorine
								String resultString = "";
								resultString += res.getString(R.string.msg_ph)
									+ ": " + result.getString("ph")
									+ ", " + res.getString(R.string.msg_chlorine)
									+ ": " + result.getString("chlorine");
								
								// Create maker
								// Anchor places the custom image in the middle of the coordinates
								// Title sets the bold title of the tooltip
								// Snippet sets the texts for the tooltip
						        MarkerOptions marker = new MarkerOptions().position(new LatLng(latitude, longitude)).anchor(0.5f,0.5f).title(result.getString("place_name")).snippet(resultString);
						        
						        // Check values are not null, if so skip the addition
						        if (!result.getString("ph").equals("null") && !result.getString("chlorine").equals("null")) {
						        	
						        	// Get the values to classify the drop
						        	float ph = Float.valueOf(result.getString("ph"));
							        float chlorine = Float.valueOf(result.getString("chlorine"));
							        
									// Select the drop image to display
							        if ((chlorine < 0.5) || (chlorine > 2) || (ph < 6.5) || (ph > 9.5)) {
							        	marker.icon(BitmapDescriptorFactory.fromResource(R.drawable.brown_drop));
							        }
							        else if (((chlorine >= 0.5) && (chlorine <= 0.9) || (chlorine >= 1.1) && (chlorine <= 2)) && (ph >= 6.5) && (ph <= 9.5)) {
							        	marker.icon(BitmapDescriptorFactory.fromResource(R.drawable.green_drop));
							        }
							        else {
							        	marker.icon(BitmapDescriptorFactory.fromResource(R.drawable.blue_drop));
							        }
							        
							        // Adding marker
							        googleMap.addMarker(marker);
						        }
							}
							
						} catch (Exception e) {
							e.printStackTrace();
						} finally {}

						break;
					}
					case HttpConnection.DID_ERROR: {
						if (showProgressDialog) {
							showProgressDialog = false;
							progressDialog.cancel();
						}
//Log.d("HttpConnection", "Markers Connection Error");
						Exception e = (Exception) message.obj;
						e.printStackTrace();
						break;
					}
				}
			}
		};

		// Set the parameters for the request to the web service for the samples uploaded
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

		// Make the POST request to the web service
		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/home/search",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
		
		// End of the request
	}

	// Save the new sample in the server
	public void newSample() {
		
		// Show a dialog while sample uploading
		progressDialog = ProgressDialog.show(Home.this, "",
				res.getString(R.string.msg_uploading_processing_data), true,
				true);

		// Retrieve input from the user
		final EditText placeNameText = (EditText) findViewById(R.id.place_name_text);
		final EditText pHText = (EditText) findViewById(R.id.ph_text);
		final EditText chlorineText = (EditText) findViewById(R.id.chlorine_text);
		final EditText placeDescriptionText = (EditText) findViewById(R.id.place_description_text);

		// Start request
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
//Log.d("HttpConnection", "Starting Connection New Sample");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
//Log.d("HttpConnection", "Connection Success New Sample");

						if (jsonResponse.get("status").toString().equals("OK")) {
							placeId = jsonResponse.getString("place_id");
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
//Log.d("HttpConnection", "Connection Error New Sample");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};
		
		// Set the parameters of the POST request with the input of the user
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(6);
		nameValuePairs.add(new BasicNameValuePair("place_name", placeNameText.getText().toString()));
		nameValuePairs.add(new BasicNameValuePair("ph", roundTwoDecimals(pHText.getText().toString())));
		nameValuePairs.add(new BasicNameValuePair("chlorine", roundTwoDecimals(chlorineText.getText().toString())));
		nameValuePairs.add(new BasicNameValuePair("comment_content", placeDescriptionText.getText().toString()));
		nameValuePairs
				.add(new BasicNameValuePair("latitude",
						latitudeGeoLocation));
		nameValuePairs
				.add(new BasicNameValuePair("longitude",
						longitudeGeoLocation));

		// Make the POST request
		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/content/new_place",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
	}

	// 
	public void uploadFiles() {

		final Handler uploadHandler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
//Log.d("HttpConnection", "Starting Connection Upload Files");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					try {
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
//Log.d("HttpConnection", "Connection Success Upload Files");

						if (jsonResponse.get("status").toString().equals("OK")) {
							attachmentsArray.remove(0);
							uploadFiles();
						} else {
							builder.setMessage(
									res.getString(R.string.msg_place_saved_successfully_no_file))
									.setCancelable(false)
									.setPositiveButton(
											"OK",
											new DialogInterface.OnClickListener() {
												public void onClick(
														DialogInterface dialog,
														int id) {
													dialog.cancel();
													attachmentsArray.remove(0);
													error_saving_image = true;
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
//Log.d("HttpConnection", "Connection Error Upload");
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
				entity.addPart("place_id", new StringBody(placeId));
				entity.addPart("comment_id", new StringBody(commentId));
				entity.addPart("type", new StringBody("image"));
				entity.addPart("file", new FileBody(f));

				new HttpConnection(uploadHandler).post(
						appState.getHttpClient(),
						appState.getServerString() + "/content/upload_file", entity);

			} catch (Exception e) {
				e.printStackTrace();

			} finally {
			}
		} else {
			progressDialog.cancel();
			if (!error_saving_image){
				error_saving_image = false;
				builder.setMessage(
					res.getString(R.string.msg_place_saved_successfully))
					.setCancelable(false)
					.setPositiveButton("OK",
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int id) {
									dialog.cancel();
								}
							});
			}
			
			// Clean text fields, geolocation and attachments
			final EditText placeNameText = (EditText) findViewById(R.id.place_name_text);
			final EditText pHText = (EditText) findViewById(R.id.ph_text);
			final EditText chlorineText = (EditText) findViewById(R.id.chlorine_text);
			final EditText placeDescriptionText = (EditText) findViewById(R.id.place_description_text);
			placeNameText.setText("");
			pHText.setText("");
			chlorineText.setText("");
			placeDescriptionText.setText("");
			latitudeGeoLocation = null;
			longitudeGeoLocation = null;
			attachmentsArray = new ArrayList<ParcelableAttachment>();
			
			// Populate again the map with the new samples
			populateMap();
			AlertDialog alert = builder.create();
			alert.show();
		}
	}

	public void addAttachment(final String filePath, String type) {

		final ParcelableAttachment attachment = new ParcelableAttachment(filePath, type);
		attachmentsArray.add(attachment);
	}
	
	public String roundTwoDecimals(String number)
	{
		Double d = Double.parseDouble(number);
		
		DecimalFormat twoDForm = new DecimalFormat("#.##");
		return String.valueOf(Double.valueOf(twoDForm.format(d)));
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		
		switch (requestCode) {
		case GEOPOSITION:
			try {
				latitudeGeoLocation = data.getExtras().getString("latitude");
				longitudeGeoLocation = data.getExtras().getString("longitude");
			} catch (Exception e) {
				latitudeGeoLocation = null;
				longitudeGeoLocation = null;
			}
			break;
		case IMAGE:
			
			if (resultCode == RESULT_OK) {

					Uri selectedImage = data.getData();
					String[] filePathColumn = { MediaStore.Images.Media.DATA };

					Cursor cursor = getContentResolver().query(selectedImage,
							filePathColumn, null, null, null);
					cursor.moveToFirst();

					int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
					String filePath = cursor.getString(columnIndex); // file path of selected image
					cursor.close();

//Log.d("File path", filePath);
					addAttachment(filePath, "image");
			}
			
			break;
		}
	}
}