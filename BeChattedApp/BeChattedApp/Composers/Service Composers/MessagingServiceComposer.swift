//
//  MessagingServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 06.09.2024.
//

import BeChattedMessaging
import BeChattedNetwork

enum MessagingServiceComposer {
  private static let baseURLString = URLProvider.baseURLString
  private static let endpoint = "/v1/message/byChannel"
  private static let url = URL(string: "\(baseURLString)\(endpoint)")!
  
  static let service = MessagingService(
    url: url,
    httpClient: URLSessionHTTPClient(),
    webSocketClient: WebSocketIOClient(url: URL(string: baseURLString)!)
  )
}
