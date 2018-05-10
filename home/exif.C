void exif(const char* focales="focales")
{
  Int_t nbins=300;
  TTree t;
  t.ReadFile(focales);
  TH1* hdx = new TH1F("hdx","hdx",nbins,-0.5,299.5);
  TH1* hfx = new TH1F("hfx","hfx",nbins,-0.5,299.5);
  TH1* hcfx = new TH1F("hcfx","hcfx",nbins,-0.5,299.5);
  TH1* hcdx = new TH1F("hcdx","hcdx",nbins,-0.5,299.5);
  t.Draw("fx>>hfx");
  t.Draw("dx>>hdx");
  t.Draw("cfx>>hcfx");
  t.Draw("cdx>>hcdx");
  hfx->SetLineColor(2);
  hcfx->SetLineColor(4);
  hcdx->SetLineColor(6);
  hfx->Draw();
  hcfx->Draw("same");
  new TCanvas;
  hdx->Draw();
  hcdx->Draw("same");
}
