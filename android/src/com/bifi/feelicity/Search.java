package com.bifi.feelicity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.bifi.feelicity.MapTools.HttpConnection;

public class Search extends Activity {

	private Activity _this = this;

	CustomApp appState;
	ProgressDialog progressDialog;
	
	Resources res;
	
	ListView listView;
	EditText searchText;
	JSONArray results;
	
	// Search parameters
	public String mode = "search";
	public String search_type = "places";
	public String search_result = "places";
	public String search_string = "";
	public String order = "date";
	public int page = 1;
	
	public final static int SUCCESS_RETURN_CODE = 1;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		appState = ((CustomApp) getApplicationContext());
		
		res = getResources();

		setContentView(R.layout.search);

		listView = (ListView) findViewById(R.id.place_list);
		listView.setTextFilterEnabled(true);
		
		listView.requestFocus();
		
		searchText = (EditText) findViewById(R.id.search_text);
		
		Button searchButton = (Button) findViewById(R.id.search_button);
		searchButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				search();
			}
		});
		
		search();
	}
	
	public void search() {
		progressDialog = ProgressDialog.show(Search.this, "", res.getString(R.string.msg_loading) + "...", true, true);
		
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					progressDialog.cancel();
					try {
						Log.d("HttpConnection", "Connection Success");
						final JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						if (jsonResponse.get("status").toString().equals("OK")) {
							
							results = jsonResponse
									.getJSONArray("results");
							
							ArrayList<String> resultsNames = new ArrayList<String>();
							for (int i = 0; i < results.length(); i++) {
								JSONObject result = results.getJSONObject(i);

								resultsNames.add(result.getString("place_name"));
							}							
							
							listView.setAdapter(new ArrayAdapter<String>(_this,
									R.layout.ellipsis_list_item, resultsNames));
							listView.setOnItemClickListener(new OnItemClickListener() {
								public void onItemClick(AdapterView<?> parent,
										View view, int position, long id) {
									try {
										Intent myIntent = new Intent(_this,
												ViewPlace.class);
										myIntent.putExtra("id", results
												.getJSONObject(position)
												.getString("place_id"));
										(_this).startActivityForResult(
												myIntent, 0);
									} catch (Exception e) {
										e.printStackTrace();
									} finally {
									}
								}
							});
							
						} else {
							EditText page_text = (EditText) findViewById(R.id.page_text);
							page_text.setVisibility(View.GONE);

							TextView pages_text = (TextView) findViewById(R.id.pages_text);
							pages_text.setVisibility(View.GONE);
							
							AlertDialog.Builder builder = new AlertDialog.Builder(
									_this);
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
		
		Log.d("search", searchText.getText().toString());

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("mode", mode));
		nameValuePairs.add(new BasicNameValuePair("search_type", search_type));
		nameValuePairs.add(new BasicNameValuePair("search_result",
				search_result));
		nameValuePairs.add(new BasicNameValuePair("order", order));
		nameValuePairs.add(new BasicNameValuePair("page", Integer
				.toString(page)));
		nameValuePairs.add(new BasicNameValuePair("search_string", searchText.getText().toString()));

		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/home/search",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
	}
}