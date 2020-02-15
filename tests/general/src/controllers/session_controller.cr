module General
  class SessionController < Controller
    @[Worker]
    def add
      key = self.body["key"].to_s
      value = self.body["value"]
      session_set_result = self.session.set(key, value).await
      return text_result("saved")
    end

    # @Worker()
    # @Route("/add-many")
    # async addMany() {
    #     const key1 = self.body.key1;
    #     const value1 = self.body.value1;
    #     const key2 = self.body.key2;
    #     const value2 = self.body.value2;
    #     await self.session.setMany({
    #         [key1]: value1,
    #         [key2]: value2
    #     })
    #     return textResult("saved");
    # }

    # @Worker()
    # async exist() {
    #     const key = self.query.key;
    #     if (await self.session.isExist(key)) {
    #         return textResult('key is found');
    #     }
    #     else {
    #         return textResult("key is not found");
    #     }

    # }

    # @Worker()
    # async get() {
    #     const key = self.query.key;
    #     self.logger.debug("key", key);
    #     const valueFromSession = await self.session.get(key);
    #     self.logger.debug("value from session", valueFromSession);
    #     return jsonResult({
    #         value: valueFromSession
    #     });
    # }

    # @Worker()
    # async update() {
    #     const key = self.body.key;
    #     const value = self.body.value;
    #     await self.session.set(key, value);
    #     return textResult("updated");
    # }

    # @Worker()
    # async remove() {
    #     const key = self.query.key;
    #     await self.session.remove(key);
    #     return textResult("removed");
    # }

    # @Worker()
    # async clear() {
    #     await self.session.clear();
    #     return textResult("cleared");
    # }

    @[Worker]
    def get_all
      #   valueFromSession = self.session.get_all.await
      #   return json_result({
      #     value: valueFromSession,
      #   })
      return text_result("saved")
    end
  end
end
