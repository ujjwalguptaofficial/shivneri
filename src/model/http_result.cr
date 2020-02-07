require "../hashes/index"

module CrystalInsideFort
  module MODEL
    include HASHES

    class HttpResult
      statusCode : HTTP::Status
      responseData : String
      contentType : String
      # file?: FileResultInfo;
      shouldRedirect? : Bool
    end
  end
end
