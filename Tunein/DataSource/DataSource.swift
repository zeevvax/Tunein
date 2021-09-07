//
// Created by Zeev Vax on 9/5/21.
//

import Foundation

class DataSource {
  static private let startLinkPath = "https://opml.radiotime.com/?partnerId=9xRsEvDb"
  private(set) var title: String?
  private(set) var topLinksList = [LinkElement]()
  private(set) var elementList = [TuneElement]()

  func shouldLoadListView() -> Bool {
    if let element = elementList.first, element.type == .audio || element.type == .link {
      return true
    }
    return false
  }

  func loadInitialData(completion: @escaping (Result<Void, Error>) -> Void) {
    loadTopLinks { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        if let firstLinkPath = self.topLinksList.first?.path {
          self.loadLinkData(path: firstLinkPath, updateTitle: false) { loadLinkResult in
            switch loadLinkResult {
            case .success:
              completion(.success)
            case .failure(let error):
              completion(.failure(error))
            }
          }
        } else {
          completion(.failure("Couldn't get top link"))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  private func loadTopLinks(completion: @escaping (Result<Void, Error>) -> Void) {
    APIHandler.shared.getRequest(path: Self.startLinkPath) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let json):
        if let responseData = self.getResponseData(json: json) {
          self.title = responseData.title
          var links = [LinkElement]()
          for entry in responseData.body {
            if let link = LinkElement(entry) {
              links.append(link)
            }
          }
          self.topLinksList = links
          completion(.success)
        } else {
          completion(.failure("Bad response"))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func loadLinkData(path: String, updateTitle: Bool = true, completion: @escaping (Result<Void, Error>) -> Void) {
    APIHandler.shared.getRequest(path: path) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let json):
        if let responseData = self.getResponseData(json: json) {
          if updateTitle {
            self.title = responseData.title
          }
          var elements = [TuneElement]()
          for entry in responseData.body {
            if let type = ElementType(entry) {
              switch type {
              case .link:
                if let element = LinkElement(entry) {
                  elements.append(element)
                }
              case .audio:
                if let element = AudioElement(entry) {
                  elements.append(element)
                }
              case .children:
                if let element = ChildrenElement(entry) {
                  elements.append(element)
                }
              }
            }
          }

          self.elementList = elements
          completion(.success)
        } else {
          completion(.failure("Bad response"))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  private func getResponseData(json: [AnyHashable: Any]) -> (title: String, body: [Any])? {
    let tuneResponse = TuneResponse(json)
    if tuneResponse.status == 200, let title = tuneResponse.title, let body = tuneResponse.body {
      return (title: title, body: body)
    }
    return nil
  }
}