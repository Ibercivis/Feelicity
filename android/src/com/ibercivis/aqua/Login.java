package com.ibercivis.aqua;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.ibercivis.aqua.R;
import com.ibercivis.aqua.MapTools.HttpConnection;

public class Login extends Activity {

	CustomApp appState;
	ProgressDialog progressDialog;
	
	Resources res;
	
	public static final String PREFS_NAME = "Credentials";
	EditText email_text;
	EditText password_text;
	
	protected static final int DO_REGISTER = 0;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);

		appState = ((CustomApp) getApplicationContext());
		
		res = getResources();
		
		email_text = (EditText) findViewById(R.id.email_text);
		password_text = (EditText) findViewById(R.id.password_text);
		
		SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
		email_text.setText(settings.getString("email", ""));
		password_text.setText(settings.getString("password", ""));

		Button login_button = (Button) findViewById(R.id.login_button);
		login_button.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				
				progressDialog = ProgressDialog.show(Login.this, "", res.getString(R.string.msg_loading)+ "...", true, true);

				Handler handler = new Handler() {
					public void handleMessage(Message message) {
						switch (message.what) {
						case HttpConnection.DID_START: {
//Log.d("HttpConnection", "Starting Connection");
							break;
						}
						case HttpConnection.DID_SUCCEED: {
							progressDialog.cancel();
							try {
								JSONObject jsonResponse = new JSONObject((String) message.obj);
//Log.d("HttpConnection", "Connection Success");
								if (jsonResponse.get("status").toString()
										.equals("OK")) {
									appState.logged = true;
									
									// We need an Editor object to make preference changes.
									// All objects are from android.context.Context
									SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
									SharedPreferences.Editor editor = settings.edit();
									editor.putString("email", email_text.getText().toString());
									editor.putString("password", password_text.getText().toString());
									editor.commit();
									
									finish();
								} else {
									
									AlertDialog.Builder builder = new AlertDialog.Builder(
											view.getContext());
									builder.setMessage(res.getString(R.string.msg_login_error))
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
//Log.d("HttpConnection", "Connection Error");
							Exception e = (Exception) message.obj;
							e.printStackTrace();
							break;
						}
						}
					}
				};

				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(
						2);
				nameValuePairs.add(new BasicNameValuePair("email", email_text
						.getText().toString()));
				nameValuePairs.add(new BasicNameValuePair("password",
						password_text.getText().toString()));

//Log.i("MyActivity", "Mail " + email_text.getText().toString() + " Password " + password_text.getText().toString());
				
				try {
					new HttpConnection(handler).post(appState.getHttpClient(), appState.getServerString()
							+ "/common/login", new UrlEncodedFormEntity(
							nameValuePairs, "utf-8"));
				} catch (Exception e) {
					e.printStackTrace();

				} finally {
				}
			}

		});

		Button register_button = (Button) findViewById(R.id.register_button);
		register_button.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent myIntent = new Intent(view.getContext(), Register.class);
				startActivityForResult(myIntent, DO_REGISTER);
			}

		});
	}
	
	protected void onActivityResult(int requestCode, int resultCode,
			Intent ReturnedIntent) {
		super.onActivityResult(requestCode, resultCode, ReturnedIntent);
		
		if (resultCode == RESULT_OK) {
			finish();
		}
	}
}