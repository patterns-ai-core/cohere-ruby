# frozen_string_literal: true

require "faraday"

module Cohere
  class Client
    attr_reader :api_key, :connection

    ENDPOINT_URL = "https://api.cohere.ai/v1"

    def initialize(api_key:)
      @api_key = api_key
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
      stop_sequence: nil,
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
        req.body[:stop_sequence] = stop_sequence if stop_sequence
        req.body[:return_likelihoods] = return_likelihoods if return_likelihoods
        req.body[:logit_bias] = logit_bias if logit_bias
        req.body[:truncate] = truncate if truncate
      end
      response.body
    end

    def embed(
      texts:,
      model: nil,
      truncate: nil
    )
      response = connection.post("embed") do |req|
        req.body = {texts: texts}
        req.body[:model] = model if model
        req.body[:truncate] = truncate if truncate
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

    def tokenize(text:)
      response = connection.post("tokenize") do |req|
        req.body = {text: text}
      end
      response.body
    end

    def detokenize(tokens:)
      response = connection.post("detokenize") do |req|
        req.body = {tokens: tokens}
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
      @connection ||= Faraday.new(url: ENDPOINT_URL) do |faraday|
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
