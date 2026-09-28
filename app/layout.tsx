import type {Metadata} from 'next';
import {cookies} from 'next/headers';
import './globals.css';
export const metadata:Metadata={metadataBase:new URL('https://ccm-shipping.still-grass-4873.chatgpt.site'),title:{default:'CCM Shipping Agency | Shipping from Egypt, made simple',template:'%s | CCM Shipping Agency'},description:'Search container shipping rates from Sokhna Port, Egypt. Book FCL and LCL shipments and track your cargo with CCM Shipping Agency.',icons:{icon:'/favicon.svg',shortcut:'/favicon.svg'},openGraph:{title:'CCM Shipping Agency',description:'Shipping from Egypt, made simple.',type:'website',locale:'en_US',alternateLocale:'ar_EG'},alternates:{canonical:'/'}};
export default async function RootLayout({children}:{children:React.ReactNode}){const c=await cookies();const ar=c.get('ccm_lang')?.value==='ar';return <html lang={ar?'ar':'en'} dir={ar?'rtl':'ltr'}><body>{children}</body></html>}
