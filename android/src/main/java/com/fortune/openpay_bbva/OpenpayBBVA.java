package com.fortune.openpay_bbva;

import android.app.Activity;

import mx.openpay.android.Openpay;
import mx.openpay.android.OperationCallBack;
import mx.openpay.android.OperationResult;
import mx.openpay.android.exceptions.OpenpayServiceException;
import mx.openpay.android.exceptions.ServiceUnavailableException;
import mx.openpay.android.model.Card;
import mx.openpay.android.model.Token;

public class OpenpayBBVA {
    private final Openpay openpay;
    public OpenpayBBVA(Openpay openpay){
        this.openpay = openpay;
    }

    public String getDeviceId(Activity activity){
        String deviceIdString = openpay.getDeviceCollectorDefaultImpl().setup(activity);
		if (deviceIdString == null) {
			return openpay.getDeviceCollectorDefaultImpl().getErrorMessage();
		} 
		return deviceIdString;
    }

}