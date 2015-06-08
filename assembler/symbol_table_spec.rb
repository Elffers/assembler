require_relative 'symbol_table'

describe SymbolTable do
  let(:st) { SymbolTable.new }
  context "#insert" do
    it "sets value of new symbol to first available register" do
      st.insert "foo"
      expect(st.table["foo"]).to eq 16
      expect(st.free).to eq 17

      st.insert "bar"
      expect(st.table["bar"]).to eq 17
      expect(st.free).to eq 18
    end
  end
end
