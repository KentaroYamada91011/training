import Head from 'next/head';

export default function Layout({ children }) {
  return (
    <div>
      <Head />
      <main>{children}</main>
    </div>
  );
}
