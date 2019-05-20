
import Foundation

enum Result<ResultType> {
  case results(ResultType)
  case error(Error)
}
