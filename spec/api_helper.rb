def test_basic_response_structure(body)
    # Test the json structure
    expect(body).to include('data')
    data = body['data']
    expect(data).to include('meta')
    expect(data).to include('output')
end

def test_failed_response_structure(body)
    expect(body).to include('data')
    data = body['data']
    expect(data).to include('meta')
    meta = data['meta']
    expect(meta).to include('code')
    expect(meta).to include('message')
end

def test_pagination(body, page, count, total_items)
    data = body['data']
    expect(data).to include('meta')
    meta = data['meta']
    expect(meta).to include('pagination')
    pagination = meta['pagination']
    expect(pagination).to include('page')
    expect(pagination['page']).to eq(page)
    expect(pagination).to include('count')
    pp = count > 50 ? 50 : count
    expect(pagination['count']).to eq(pp)
    expect(pagination).to include('total_items')
    expect(pagination['total_items']).to eq(total_items)
    expect(pagination).to include('total_pages')

    expect(pagination['total_pages']).to eq(((total_items.to_f / pp).ceil))
end

def test_error_response(response, code, message)
    body = JSON.parse(response.body)
    test_failed_response_structure(body)
    meta = body['data']['meta']
    expect(meta['code']).to eq(code)
    expect(meta['message']).to eq(message)
end

def test_bad_request_response(response, message)
    test_error_response(response, StatusCodes::BAD_REQUEST, message)
end

def test_forbidden_request_response(response, message)
    test_error_response(response, StatusCodes::FORBIDDEN, message)
end

