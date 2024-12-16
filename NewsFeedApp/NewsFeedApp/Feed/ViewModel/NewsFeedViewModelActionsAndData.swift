//
//  NewsFeedViewModelActionsAndData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

protocol NewsFeedViewModelActionsAndData {
	var data: NewsFeedViewModelData { get }
	var viewActions: NewsFeedViewModelActions { get }
}
