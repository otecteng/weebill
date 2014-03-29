require 'spec_helper'

hash={:FromUserName=>"from",:ToUserName=>"to"}

describe SiteWorkersController do
	describe "GET wx_index" do
	    it "return the text" do
	        get :wx_index, {:echostr=>"wahhh"}   
	        expect(response.body).to eq("wahhh")
	    end
    end


    describe "POST wx_create" do
	    it "Text (deal with the reg)" do
	    	post :wx_create, {:xml=>{:FromUserName=>"from",:ToUserName=>"to",:MsgType=>"text",:Content=>"reg"}}
	        p response.body
	    end

	    it "Text (deal with the st)" do
	    	post :wx_create, {:xml=>{:FromUserName=>"from",:ToUserName=>"to",:MsgType=>"text",:Content=>"reg"}}
	        p response.body
	    end

	    it "deal with the image" do
	    	post :wx_create, {:xml=>{:FromUserName=>"from",:ToUserName=>"to",:MsgType=>"image",:Content=>"reg"}}
	        p response.body
	    end


	    it "deal with the locaton" do
	    	post :wx_create, {:xml=>{:FromUserName=>"from",:ToUserName=>"to",:MsgType=>"location",:Content=>"wahhh"}}
	        expect(response.body).to eq("wahhh")
	    end


	    it "deal with the link" do
	    	post :wx_create, {:xml=>{:FromUserName=>"from",:ToUserName=>"to",:MsgType=>"link",:Content=>"wahhh"}}
	        expect(response.body).to eq("wahhh")
	    end

    end
end