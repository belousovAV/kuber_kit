require 'spec_helper'

RSpec.describe Indocker::Core::Templates::TemplateStore do
  subject{ Indocker::Core::Templates::TemplateStore.new }

  context "#get_global" do
    it "returns global template" do
      template = Indocker::Core::Templates::ArtifactFile.new(:default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(template)

      expect(subject.get_global(:default)).to eq(template)
    end

    it "raises error if template is not found" do
      expect{ subject.get_global(:default) }.to raise_error(Indocker::Core::Templates::TemplateStore::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration template" do
      template = Indocker::Core::Templates::ArtifactFile.new(:production_default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(template)
      test_helper.configuration_store.define(:production).use_template(:production_default, as: :default)
      Indocker.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(template)
    end

    it "returns nil if template is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end

  context "#add" do
    it "doesn't allow adding template twice" do
      template = Indocker::Core::Templates::ArtifactFile.new(:default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(template)

      expect{ subject.add(template) }.to raise_error(Indocker::Core::Templates::TemplateStore::AlreadyAddedError)
    end

    it "doesn't allow adding not template class" do
      expect{ subject.add(12) }.to raise_error(ArgumentError)
    end
  end
end