# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cohere::Client do
  subject { described_class.new(api_key: "123") }

  describe "#generate" do
    let(:generate_result) { JSON.parse(File.read("spec/fixtures/generate.json")) }
    let(:response) { OpenStruct.new(body: generate_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("generate")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.generate(
        prompt: "Once upon a time in a magical land called"
      ).dig("generations").first.dig("text")).to eq(" The Past there was a Game called Warhammer Fantasy Battle.")
    end
  end

  describe "#chat" do
    let(:generate_result) { JSON.parse(File.read("spec/fixtures/chat.json")) }
    let(:response) { OpenStruct.new(body: generate_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("chat")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.chat(
        model: "command-r-plus-08-2024",
        messages: [{role: "user", content: "Hey! How are you?"}]
      ).dig("message", "content", 0, "text")).to eq("I'm doing well, thank you for asking! As an AI language model, I don't have emotions or feelings, but I'm designed to provide helpful and informative responses to assist you in the best way I can. Is there anything you'd like to know or discuss today?")
    end
  end

  describe "#embed" do
    let(:embed_result) { JSON.parse(File.read("spec/fixtures/embed.json")) }
    let(:response) { OpenStruct.new(body: embed_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("embed")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.embed(
        model: "embed-english-v3.0",
        texts: ["hello", "goodbye"],
        input_type: "classification",
        embedding_types: ["float"]
      ).dig("embeddings", "float")).to eq([[0.017578125, -0.009162903, -0.046325684]])
    end
  end

  describe "#rerank" do
    let(:embed_result) { JSON.parse(File.read("spec/fixtures/rerank.json")) }
    let(:response) { OpenStruct.new(body: embed_result) }
    let(:docs) {
      [
        "Carson City is the capital city of the American state of Nevada.",
        "The Commonwealth of the Northern Mariana Islands is a group of islands in the Pacific Ocean. Its capital is Saipan.",
        "Capitalization or capitalisation in English grammar is the use of a capital letter at the start of a word. English usage varies from capitalization in other languages.",
        "Washington, D.C. (also known as simply Washington or D.C., and officially as the District of Columbia) is the capital of the United States. It is a federal district.",
        "Capital punishment (the death penalty) has existed in the United States since beforethe United States was a country. As of 2017, capital punishment is legal in 30 of the 50 states."
      ]
    }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("rerank")
        .and_return(response)
    end

    it "returns a response" do
      expect(
        subject
          .rerank(model: "rerank-english-v3.0", query: "What is the capital of the United States?", documents: docs)
          .dig("results")
          .map { |h| h["index"] }
      ).to eq([3, 4, 2, 0, 1])
    end
  end

  describe "#classify" do
    let(:classify_result) { JSON.parse(File.read("spec/fixtures/classify.json")) }
    let(:response) { OpenStruct.new(body: classify_result) }

    let(:examples) {
      [
        {text: "Dermatologists don't like her!", label: "Spam"},
        {text: "Hello, open to this?", label: "Spam"},
        {text: "Your parcel will be delivered today", label: "Not spam"},
        {text: "Review changes to our Terms and Conditions", label: "Not spam"}
      ]
    }

    let(:inputs) {
      [
        "Confirm your email address",
        "hey i need u to send some $"
      ]
    }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("classify")
        .and_return(response)
    end

    it "returns a response" do
      res = subject.classify(
        model: "embed-multilingual-v2.0",
        inputs: inputs,
        examples: examples
      ).dig("classifications")

      expect(res.first.dig("prediction")).to eq("Not spam")
      expect(res.last.dig("prediction")).to eq("Spam")
    end
  end

  describe "#tokenize" do
    let(:tokenize_result) { JSON.parse(File.read("spec/fixtures/tokenize.json")) }
    let(:response) { OpenStruct.new(body: tokenize_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("tokenize")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.tokenize(
        model: "command-r-plus-08-2024",
        text: "Hello, world!"
      ).dig("tokens")).to eq([33555, 1114, 34])
    end
  end

  describe "#detokenize" do
    let(:detokenize_result) { JSON.parse(File.read("spec/fixtures/detokenize.json")) }
    let(:response) { OpenStruct.new(body: detokenize_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("detokenize")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.detokenize(
        model: "command-r-plus-08-2024",
        tokens: [33555, 1114, 34]
      ).dig("text")).to eq("hello world!")
    end
  end

  describe "#detect_language" do
    let(:detect_language_result) { JSON.parse(File.read("spec/fixtures/detect_language.json")) }
    let(:response) { OpenStruct.new(body: detect_language_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("detect-language")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.detect_language(
        texts: ["Здравствуй, Мир"]
      ).dig("results").first.dig("language_code")).to eq("ru")
    end
  end

  describe "#summarize" do
    let(:summarize_result) { JSON.parse(File.read("spec/fixtures/summarize.json")) }
    let(:response) { OpenStruct.new(body: summarize_result) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("summarize")
        .and_return(response)
    end

    it "returns a response" do
      expect(subject.summarize(
        text: "Ice cream is a sweetened frozen food typically eaten as a snack or dessert. " \
              "It may be made from milk or cream and is flavoured with a sweetener, " \
              "either sugar or an alternative, and a spice, such as cocoa or vanilla, " \
              "or with fruit such as strawberries or peaches. " \
              "It can also be made by whisking a flavored cream base and liquid nitrogen together. " \
              "Food coloring is sometimes added, in addition to stabilizers. " \
              "The mixture is cooled below the freezing point of water and stirred to incorporate air spaces " \
              "and to prevent detectable ice crystals from forming. The result is a smooth, " \
              "semi-solid foam that is solid at very low temperatures (below 2 °C or 35 °F). " \
              "It becomes more malleable as its temperature increases.\n\n" \
              "The meaning of the name \"ice cream\" varies from one country to another. " \
              "In some countries, such as the United States, \"ice cream\" applies only to a specific variety, " \
              "and most governments regulate the commercial use of the various terms according to the " \
              "relative quantities of the main ingredients, notably the amount of cream. " \
              "Products that do not meet the criteria to be called ice cream are sometimes labelled " \
              "\"frozen dairy dessert\" instead. In other countries, such as Italy and Argentina, " \
              "one word is used fo\r all variants. Analogues made from dairy alternatives, " \
              "such as goat's or sheep's milk, or milk substitutes " \
              "(e.g., soy, cashew, coconut, almond milk or tofu), are available for those who are " \
              "lactose intolerant, allergic to dairy protein or vegan."
      ).dig("summary")).to eq("Ice cream is a frozen dessert made from dairy products or non-dairy substitutes. It is flavoured with a sweetener and a spice or with fruit. It is smooth and semi-solid at low temperatures.")
    end
  end
end
