package com.bifi.feelicity;

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
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.bifi.feelicity.MapTools.HttpConnection;

public class Register extends Activity {
	
	ProgressDialog progressDialog;
	
	private Resources res;
	
	public final static int SUCCESS_RETURN_CODE = 1;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.register);
		
		final CustomApp appState = ((CustomApp) getApplicationContext());
		
		res = getResources();

		Button send_button = (Button) findViewById(R.id.send_button);
		
		final EditText email_text = (EditText) findViewById(R.id.email_text);
		final EditText nickname_text = (EditText) findViewById(R.id.nickname_text);
		final EditText password_text = (EditText) findViewById(R.id.password_text);
		final EditText confirm_password_text = (EditText) findViewById(R.id.confirm_password_text);
		
		send_button.setOnClickListener(new View.OnClickListener() {
			public void onClick(final View view) {
				String alertString = new String("");
				if (email_text.getText().toString().equals("")) {
					alertString = res.getString(R.string.msg_email_mandatory);
				} else if (nickname_text.getText().toString().equals("")) {
					alertString = res.getString(R.string.msg_nickname_mandatory);
				} else if (password_text.getText().toString().equals("")) {
					alertString = res.getString(R.string.msg_password_mandatory);
				} else if (confirm_password_text.getText().toString().equals("")) {
					alertString = res.getString(R.string.msg_password_confirmation_mandatory);
				} else if (!password_text.getText().toString().equals(confirm_password_text.getText().toString())) {
					alertString = res.getString(R.string.msg_password_confirmation_doesnt_match);
				}
				
				if (!alertString.equals("")){
					AlertDialog.Builder builder = new AlertDialog.Builder(
							view.getContext());
					builder.setMessage(
							alertString)
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
					return;
				}
				
				progressDialog = ProgressDialog.show(Register.this, "", res.getString(R.string.msg_loading) + "...", true, true);

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
								JSONObject jsonResponse = new JSONObject((String) message.obj);
								Log.d("HttpConnection", "Connection Success");
								if (jsonResponse.get("status").toString()
										.equals("OK")) {
									appState.logged = true;
									Intent intent = new Intent();
									setResult(SUCCESS_RETURN_CODE, intent);
									finish();
								} else {
									AlertDialog.Builder builder = new AlertDialog.Builder(
											view.getContext());
									builder.setMessage(
											jsonResponse.get("message")
													.toString())
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

				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(
						2);
				nameValuePairs.add(new BasicNameValuePair("email", email_text
						.getText().toString()));
				nameValuePairs.add(new BasicNameValuePair("password",
						password_text.getText().toString()));
				nameValuePairs.add(new BasicNameValuePair("nickname", nickname_text
						.getText().toString()));

				try {
					new HttpConnection(handler).post(appState.getHttpClient(), appState.getServerString()
							+ "/register/save", new UrlEncodedFormEntity(
							nameValuePairs, "utf-8"));
				} catch (Exception e) {
					e.printStackTrace();

				} finally {
				}
			}

		});
	}
}