require 'spec_helper'

describe Cadenza::ContextObject do
  subject { TestContextObject.new }

  it 'invokes public methods' do
    expect(subject.send(:invoke_context_method, 'public_visibility_method')).to eq(123)
  end

  it "doesn't invoke private methods" do
    expect(subject.send(:invoke_context_method, 'private_visibility_method')).to eq nil
  end

  it "doesn't invoke protected methods" do
    expect(subject.send(:invoke_context_method, 'protected_visibility_method')).to eq nil
  end

  it 'invokes before_method if defined' do
    expect(subject).to receive(:before_method).once
    subject.send(:invoke_context_method, 'public_visibility_method')
  end

  it 'invokes after_method if defined' do
    expect(subject).to receive(:after_method).once
    subject.send(:invoke_context_method, 'public_visibility_method')
  end

  it "invokes missing_context_method if trying to invoke a method which doesn't exist" do
    expect(subject).to receive(:missing_context_method).with('foo').once
    subject.send(:invoke_context_method, 'foo')
  end

  context '#context_methods' do
    it 'returns only the public methods defined on it, not public methods of Object' do
      expect(subject.send(:context_methods)).to eq(%w(public_visibility_method))
    end
  end
end
