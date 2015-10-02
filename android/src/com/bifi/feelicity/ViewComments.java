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

public class ViewComments extends Activity {

	private Activity _this = this;

	CustomApp appState;
	ProgressDialog progressDialog;
	Resources res;

	String placeId;
	int page = 1;

	ListView listView;
	JSONArray comments;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		appState = ((CustomApp) getApplicationContext());
		res = getResources();

		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			placeId = extras.getString("id");
		}

		setContentView(R.layout.viewcomments);

		listView = (ListView) findViewById(R.id.comment_list);
		listView.setTextFilterEnabled(true);

		listView.requestFocus();

		search();
	}

	public void search() {
		progressDialog = ProgressDialog.show(ViewComments.this, "",
				res.getString(R.string.msg_loading) + "...", true, true);

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

							// Setup the page controls
							int currentPage = jsonResponse
									.getInt("current_page");
							int totalPages = jsonResponse.getInt("pages");

							EditText page_text = (EditText) findViewById(R.id.page_text);
							page_text.setText(Integer.toString(currentPage));

							TextView pages_text = (TextView) findViewById(R.id.pages_text);
							pages_text.setText(res.getString(R.string.msg_of)
									+ " " + Integer.toString(totalPages));
							
							Button newCommentButton = (Button) findViewById(R.id.new_comment);
							newCommentButton
									.setOnClickListener(new View.OnClickListener() {

										public void onClick(final View view) {
											if (appState.logged) {
												Intent i = new Intent(
														ViewComments.this,
														NewComment.class);
												i.putExtra("placeId", placeId);
												startActivityForResult(i, 0);
											} else {
												AlertDialog.Builder builder = new AlertDialog.Builder(
														_this);
												builder.setMessage(
														res.getString(R.string.msg_you_must_login))
														.setCancelable(false)
														.setPositiveButton(
																res.getString(R.string.btn_login),
																new DialogInterface.OnClickListener() {
																	public void onClick(
																			DialogInterface dialog,
																			int id) {
																		Intent myIntent = new Intent(
																				_this,
																				Login.class);
																		startActivityForResult(
																				myIntent,
																				0);
																	}
																})
														.setNegativeButton(
																res.getString(R.string.btn_close),
																new DialogInterface.OnClickListener() {
																	public void onClick(
																			DialogInterface dialog,
																			int id) {
																		dialog.cancel();
																	}
																});
												AlertDialog alert = builder
														.create();
												alert.show();
											}
										}
									});
							newCommentButton.setVisibility(View.VISIBLE);

							comments = jsonResponse.getJSONArray("comments");

							ArrayList<String> comments_content = new ArrayList<String>();

							Log.d("HttpConnection", comments.toString());
							for (int i = 0; i < comments.length(); i++) {
								if (!comments.getJSONObject(i)
										.has("deleted_on")) {
									comments_content.add((comments
											.getJSONObject(i))
											.getString("comment_content"));
								} else {
									comments_content.add("Comment removed");
								}
							}
							listView.setAdapter(new ArrayAdapter<String>(_this,
									R.layout.ellipsis_list_item,
									comments_content));
							listView.setOnItemClickListener(new OnItemClickListener() {
								public void onItemClick(AdapterView<?> parent,
										View view, int position, long id) {
									// When clicked, show a toast with the
									// TextView text
									try {
										Intent myIntent = new Intent(_this,
												ViewComment.class);
										myIntent.putExtra(
												"place_name",
												jsonResponse.getJSONObject(
														"place").getString(
														"place_name"));
										myIntent.putExtra("comment", comments
												.getJSONObject(position)
												.toString());
										(_this).startActivityForResult(
												myIntent, 0);
									} catch (Exception e) {
										e.printStackTrace();
									} finally {
									}
								}
							});
						} else {
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

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
		nameValuePairs.add(new BasicNameValuePair("id", placeId));
		nameValuePairs.add(new BasicNameValuePair("page", Integer
				.toString(page)));

		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/view/get_place_data",
					new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
	}
	
	protected void onActivityResult(int requestCode, int resultCode,
			Intent ReturnedIntent) {
		super.onActivityResult(requestCode, resultCode, ReturnedIntent);
		if (resultCode == RESULT_OK) {
			search();
		}
	}
}