package com.ibercivis.aqua.MapTools;

import android.os.Parcel;
import android.os.Parcelable;

public class ParcelableAttachment implements Parcelable {

	public String path;
	public String type;

    public ParcelableAttachment(String path, String type) {
        this.path = path;
        this.type = type;
   }

    public String getPath() {
         return path;
    }
    
    public String getType() {
		return type;
	}

    public int describeContents() {
        return 0;
    }

    public void writeToParcel(Parcel out, int flags) {
    	out.writeString(path);
    	out.writeString(type);
    }

    public static final Parcelable.Creator<ParcelableAttachment> CREATOR
            = new Parcelable.Creator<ParcelableAttachment>() {
        public ParcelableAttachment createFromParcel(Parcel in) {
            return new ParcelableAttachment(in);
        }

        public ParcelableAttachment[] newArray(int size) {
            return new ParcelableAttachment[size];
        }
    };

    private ParcelableAttachment(Parcel in) {
    	path = in.readString();
        type = in.readString();
    }
}