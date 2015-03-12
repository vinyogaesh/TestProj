package com.tarnea.rest;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.ClientRequest;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.filter.ClientFilter;

import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_USERNAME;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_PASSWORD;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_PARTY_ID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_CONTENT_TYPE;

import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_VALUE_PASSWORD;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_VALUE_USERNAME;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_VALUE_CONTENT_TYPE;
public class RestClient {
	public static String partyId;
	/**
	 * Getting Header for REST
	 * @return
	 * @author vinoth
	 */
	public static Client getClient() {

		Client client = Client.create(ClientHelper.configureClient());

		client.addFilter(new ClientFilter() {
			@Override
			public ClientResponse handle(ClientRequest cr)
					throws ClientHandlerException {
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_USERNAME, SERVICE_PARAMETER_VALUE_USERNAME);
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_PASSWORD, SERVICE_PARAMETER_VALUE_PASSWORD);
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_PARTY_ID, partyId);
				return getNext().handle(cr);
			}
		});
		return client;
	}

	/**
	 * Getting headers to REST for posting
	 * @return
	 */
	public static Client getClientToPost() {

		Client client = Client.create(ClientHelper.configureClient());

		client.addFilter(new ClientFilter() {
			@Override
			public ClientResponse handle(ClientRequest cr)
					throws ClientHandlerException {
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_USERNAME, SERVICE_PARAMETER_VALUE_USERNAME);
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_PASSWORD, SERVICE_PARAMETER_VALUE_PASSWORD);
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_PARTY_ID, partyId);
				cr.getHeaders().add(SERVICE_PARAMETER_KEY_CONTENT_TYPE, SERVICE_PARAMETER_VALUE_CONTENT_TYPE);
				return getNext().handle(cr);
			}
		});
		return client;
	}
}