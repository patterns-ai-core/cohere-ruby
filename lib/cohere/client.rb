# frozen_string_literal: true

require "faraday"

module Cohere
  class Client
    attr_reader :api_key, :connection

    ENDPOINT_URL = "https://api.cohere.ai/v1"

    def initialize(api_key:, timeout: nil)
      @api_key = api_key
      @timeout = timeout
    end

    def chat(
      message: nil,
      model: nil,
      stream: false,
      preamble: nil,
      preamble_override: nil,
      chat_history: nil,
      conversation_id: nil,
      prompt_truncation: nil,
      connectors: [],
      search_queries_only: false,
      documents: [],
      citation_quality: nil,
      temperature: nil,
      max_tokens: nil,
      k: nil,
      p: nil,
      seed: nil,
      frequency_penalty: nil,
      presence_penalty: nil,
      tools: [],
      tool_results: nil,
      force_single_step: true, # default to true for backwards compatibility prior 6/10/2024 change
      &block
    )
      response = connection.post("chat") do |req|
        req.body = {}

        req.body[:message] = message if message
        req.body[:model] = model if model
        if stream || block
          req.body[:stream] = true
          req.options.on_data = block if block
        end
        req.body[:preamble] = preamble if preamble
        req.body[:preamble_override] = preamble_override if preamble_override
        req.body[:chat_history] = chat_history if chat_history
        req.body[:conversation_id] = conversation_id if conversation_id
        req.body[:prompt_truncation] = prompt_truncation if prompt_truncation
        req.body[:connectors] = connectors if connectors
        req.body[:search_queries_only] = search_queries_only if search_queries_only
        req.body[:documents] = documents if documents
        req.body[:citation_quality] = citation_quality if citation_quality
        req.body[:temperature] = temperature if temperature
        req.body[:max_tokens] = max_tokens if max_tokens
        req.body[:k] = k if k
        req.body[:p] = p if p
        req.body[:seed] = seed if seed
        req.body[:frequency_penalty] = frequency_penalty if frequency_penalty
        req.body[:presence_penalty] = presence_penalty if presence_penalty
        req.body[:tools] = tools if tools
        req.body[:tool_results] = tool_results if tool_results
        req.body[:force_single_step] = force_single_step
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

    def embed(
      texts:,
      model: nil,
      input_type: nil,
      truncate: nil
    )
      response = connection.post("embed") do |req|
        req.body = {texts: texts}
        req.body[:model] = model if model
        req.body[:input_type] = input_type if input_type
        req.body[:truncate] = truncate if truncate
      end
      response.body
    end

    def rerank(
      query:,
      documents: [],
      top_n: nil,
      rank_fields: nil,
      return_documents: nil,
      max_chunks_per_doc: nil,
      model: nil
    )
      response = connection.post("rerank") do |req|
        req.body = { query:, documents: }
        req.body[:top_n] = top_n if top_n
        req.body[:rank_fields] = rank_fields if rank_fields
        req.body[:return_documents] = return_documents if return_documents
        req.body[:max_chunks_per_doc] = max_chunks_per_doc if max_chunks_per_doc
        req.body[:model] = model if model
      end
      response.body
    end

    def classify(
      inputs:,
      examples:,
      model: nil,
      present: nil,
      truncate: nil
    )
      response = connection.post("classify") do |req|
        req.body = {
          inputs: inputs,
          examples: examples
        }
        req.body[:model] = model if model
        req.body[:present] = present if present
        req.body[:truncate] = truncate if truncate
      end
      response.body
    end

    def tokenize(text:, model: nil)
      response = connection.post("tokenize") do |req|
        req.body = model.nil? ? {text: text} : {text: text, model: model}
      end
      response.body
    end

    def detokenize(tokens:, model: nil)
      response = connection.post("detokenize") do |req|
        req.body = model.nil? ? {tokens: tokens} : {tokens: tokens, model: model}
      end
      response.body
    end

    def detect_language(texts:)
      response = connection.post("detect-language") do |req|
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
      response = connection.post("summarize") do |req|
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

    # standard:disable Lint/DuplicateMethods
    def connection
      @connection ||= Faraday.new(url: ENDPOINT_URL, request: {timeout: @timeout}) do |faraday|
        if api_key
          faraday.request :authorization, :Bearer, api_key
        end
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end
    # standard:enable Lint/DuplicateMethods
  end
end
