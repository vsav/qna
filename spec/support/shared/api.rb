shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns status 401 if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'returns status 401 if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Returns all items' do
  it 'returns all items of resource' do
    expect(resource_response.size).to eq resource.size
  end
end

shared_examples_for 'Returns all public fields' do
  it 'returns all public fields for resource' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end
