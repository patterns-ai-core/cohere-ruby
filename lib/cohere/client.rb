# frozen_string_literal: true

require "faraday"

module Cohere
  class Client
    attr_reader :api_key, :connection

    def initialize(api_key:, timeout: nil)
      @api_key = api_key
      @timeout = timeout
    end

    # Generates a text response to a user message and streams it down, token by token
    def chat(
      model:,
      messages:,
      stream: false,
      tools: [],
      documents: [],
      citation_options: nil,
      response_format: nil,
      safety_mode: nil,
      max_tokens: nil,
      stop_sequences: nil,
      temperature: nil,
      seed: nil,
      frequency_penalty: nil,
      presence_penalty: nil,
      k: nil,
      p: nil,
      logprops: nil,
      &block
    )
      response = v2_connection.post("chat") do |req|
        req.body = {}

        req.body[:model] = model
        req.body[:messages] = messages if messages
        req.body[:tools] = tools if tools.any?
        req.body[:documents] = documents if documents.any?
        req.body[:citation_options] = citation_options if citation_options
        req.body[:response_format] = response_format if response_format
        req.body[:safety_mode] = safety_mode if safety_mode
        req.body[:max_tokens] = max_tokens if max_tokens
        req.body[:stop_sequences] = stop_sequences if stop_sequences
        req.body[:temperature] = temperature if temperature
        req.body[:seed] = seed if seed
        req.body[:frequency_penalty] = frequency_penalty if frequency_penalty
        req.body[:presence_penalty] = presence_penalty if presence_penalty
        req.body[:k] = k if k
        req.body[:p] = p if p
        req.body[:logprops] = logprops if logprops

        if stream || block
          req.body[:stream] = true
          req.options.on_data = block if block
        end
      end
      response.body
    end

    # This endpoint generates realistic text conditioned on a given input.
    def generate(
      prompt:,
      model: nil,
      num_generations: nil,
      max_tokens: nil,
      preset: nil,
      temperature: nil,
      k: nil,
      p: nil,
      frequency_penalty: nil,
      presence_penalty: nil,
      end_sequences: nil,
      stop_sequences: nil,
      return_likelihoods: nil,
      logit_bias: nil,
      truncate: nil
    )
      response = connection.post("generate") do |req|
        req.body = {prompt: prompt}
        req.body[:model] = model if model
        req.body[:num_generations] = num_generations if num_generations
        req.body[:max_tokens] = max_tokens if max_tokens
        req.body[:preset] = preset if preset
        req.body[:temperature] = temperature if temperature
        req.body[:k] = k if k
        req.body[:p] = p if p
        req.body[:frequency_penalty] = frequency_penalty if frequency_penalty
        req.body[:presence_penalty] = presence_penalty if presence_penalty
        req.body[:end_sequences] = end_sequences if end_sequences
        req.body[:stop_sequences] = stop_sequences if stop_sequences
        req.body[:return_likelihoods] = return_likelihoods if return_likelihoods
        req.body[:logit_bias] = logit_bias if logit_bias
        req.body[:truncate] = truncate if truncate
      end
      response.body
    end

    # This endpoint returns text embeddings. An embedding is a list of floating point numbers that captures semantic information about the text that it represents.
    def embed(
      model:,
      input_type:,
      embedding_types:,
      texts: nil,
      images: nil,
      truncate: nil
    )
      response = v2_connection.post("embed") do |req|
        req.body = {
          model: model,
          input_type: input_type,
          embedding_types: embedding_types
        }
        req.body[:texts] = texts if texts
        req.body[:images] = images if images
        req.body[:truncate] = truncate if truncate
      end
      response.body
    end

    # This endpoint takes in a query and a list of texts and produces an ordered array with each text assigned a relevance score.
    def rerank(
      model:,
      query:,
      documents:,
      top_n: nil,
      rank_fields: nil,
      return_documents: nil,
      max_chunks_per_doc: nil
    )
      response = v2_connection.post("rerank") do |req|
        req.body = {
          model: model,
          query: query,
          documents: documents
        }
        req.body[:top_n] = top_n if top_n
        req.body[:rank_fields] = rank_fields if rank_fields
        req.body[:return_documents] = return_documents if return_documents
        req.body[:max_chunks_per_doc] = max_chunks_per_doc if max_chunks_per_doc
      end
      response.body
    end

    # This endpoint makes a prediction about which label fits the specified text inputs best.
    def classify(
      model:,
      inputs:,
      examples: nil,
      preset: nil,
      truncate: nil
    )
      response = v1_connection.post("classify") do |req|
        req.body = {
          model: model,
          inputs: inputs
        }
        req.body[:examples] = examples if examples
        req.body[:preset] = preset if preset
        req.body[:truncate] = truncate if truncate
      end
      response.body
    end

    # This endpoint splits input text into smaller units called tokens using byte-pair encoding (BPE).
    def tokenize(text:, model:)
      response = v1_connection.post("tokenize") do |req|
        req.body = {text: text, model: model}
      end
      response.body
    end

    # This endpoint takes tokens using byte-pair encoding and returns their text representation.
    def detokenize(tokens:, model:)
      response = v1_connection.post("detokenize") do |req|
        req.body = {tokens: tokens, model: model}
      end
      response.body
    end

    def detect_language(texts:)
      response = v1_connection.post("detect-language") do |req|
        req.body = {texts: texts}
      end
      response.body
    end

    def summarize(
      text:,
      length: nil,
      format: nil,
      model: nil,
      extractiveness: nil,
      temperature: nil,
      additional_command: nil
    )
      response = v1_connection.post("summarize") do |req|
        req.body = {text: text}
        req.body[:length] = length if length
        req.body[:format] = format if format
        req.body[:model] = model if model
        req.body[:extractiveness] = extractiveness if extractiveness
        req.body[:temperature] = temperature if temperature
        req.body[:additional_command] = additional_command if additional_command
      end
      response.body
    end

    private

    def v1_connection
      @connection ||= Faraday.new(url: "https://api.cohere.ai/v1", request: {timeout: @timeout}) do |faraday|
        faraday.request :authorization, :Bearer, api_key
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    def v2_connection
      @connection ||= Faraday.new(url: "https://api.cohere.com/v2", request: {timeout: @timeout}) do |faraday|
        faraday.request :authorization, :Bearer, api_key
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
