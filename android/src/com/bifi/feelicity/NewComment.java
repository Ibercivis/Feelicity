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
import android.widget.Button;
import android.widget.EditText;

import com.bifi.feelicity.MapTools.HttpConnection;
import com.bifi.feelicity.MapTools.ParcelableAttachment;
import com.google.android.maps.GeoPoint;

public class NewComment extends Activity {

	CustomApp appState;
	Activity _this = this;

	private Resources res;

	String placeId;
	String commentId = new String();

	GeoPoint commentGeoLocation;
	ArrayList<ParcelableAttachment> attachmentsArray = new ArrayList<ParcelableAttachment>();
	ArrayList<String> addressArray = new ArrayList<String>();
	String notificationMessage = new String();

	AlertDialog.Builder builder;
	ProgressDialog progressDialog;

	protected static final int PICK_GEOPOSITION = 1;
	protected static final int PICK_ATTACHMENTS = 2;
	protected static final int PICK_ADDRESSES = 3;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.newcomment);

		appState = ((CustomApp) getApplicationContext());

		res = getResources();

		builder = new AlertDialog.Builder(this);

		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			placeId = extras.getString("placeId");
		}

		initUI();
	}

	public void initUI() {
		final EditText commentContentText = (EditText) findViewById(R.id.comment_content_text);

		final Button attachmentsButton = (Button) findViewById(R.id.attachments_button);
		attachmentsButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				Intent i = new Intent(NewComment.this, UploadFiles.class);
				i.putParcelableArrayListExtra("attachmentsArray",
						attachmentsArray);
				startActivityForResult(i, PICK_ATTACHMENTS);
			}
		});

		final Button saveButton = (Button) findViewById(R.id.save_button);
		saveButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				String alertString = new String("");
				if (commentContentText.getText().toString().equals("")) {
					alertString = res
							.getString(R.string.msg_comment_content_mandatory);
				}

				if (!alertString.equals("")) {
					builder.setMessage(alertString)
							.setCancelable(false)
							.setPositiveButton("OK",
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog, int id) {
											dialog.cancel();
										}
									});
					AlertDialog alert = builder.create();
					alert.show();
					return;
				}

				newComment();
			}

		});
	}

	public void newComment() {

		progressDialog = ProgressDialog.show(NewComment.this, "",
				res.getString(R.string.msg_uploading_processing_data), true,
				true);

		final EditText commentTitleText = (EditText) findViewById(R.id.comment_title_text);
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

		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
		nameValuePairs.add(new BasicNameValuePair("place_id", placeId));
		nameValuePairs.add(new BasicNameValuePair("comment_title",
				commentTitleText.getText().toString()));
		nameValuePairs.add(new BasicNameValuePair("comment_content",
				commentContentText.getText().toString()));

		try {
			new HttpConnection(handler).post(appState.getHttpClient(),
					appState.getServerString() + "/content/new_comment",
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
				entity.addPart("type",
						new StringBody(attachmentsArray.get(0).getType()));
				if (attachmentsArray.get(0).getType().equals("image")) {
					entity.addPart("file", new FileBody(f));
				} else {
					entity.addPart("file",
							new StringBody(attachmentsArray.get(0).getPath()));
				}

				new HttpConnection(uploadHandler)
						.post(appState.getHttpClient(),
								appState.getServerString()
										+ "/content/upload_file", entity);
			} catch (Exception e) {
				e.printStackTrace();

			} finally {
			}
		} else {
			progressDialog.cancel();
			builder.setMessage(
					res.getString(R.string.msg_comment_saved_successfully))
					.setCancelable(false)
					.setPositiveButton(
							"OK",
							new DialogInterface.OnClickListener() {
								public void onClick(
										DialogInterface dialog,
										int id) {
									Intent intent = new Intent();
									setResult(RESULT_OK, intent);
									finish();
								}
							});
			AlertDialog alert = builder.create();
			alert.show();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		Bundle extras = data.getExtras();
		switch (requestCode) {
		case PICK_ATTACHMENTS:
			attachmentsArray = extras
					.getParcelableArrayList("attachmentsArray");
			break;
		}
	}
}